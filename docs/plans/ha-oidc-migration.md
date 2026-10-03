# Home Assistant: migrate LDAP script login → authentik OIDC (hass-oidc-auth)

Goal: replace `/config/ldap-auth.py` (command_line auth provider) with a real OIDC flow
via `christiaangoossens/hass-oidc-auth`, keeping authentik as IdP. No header/proxy trust
(unlike the archived `auth_header` approach that caused problems before) — full browser
redirect flow ("Login with authentik" button), works in browsers and companion apps.

Facts verified for this infra (2026-10-04):
- authentik 2026.8.3, managed by Terraform in `infrastructure/terraform/authentik/`
  (run from repo root `/infrastructure`; SOPS settings in `settings/authentik.yaml`).
- Existing OIDC app pattern: `app-okd.tf` (oauth2 provider, strict redirect URIs).
- Group binding pattern: `app-default-ingress.tf` (policy binding to group).
- LDAP filter today requires `memberOf=cn=default_ingress` → policy binding below keeps parity.
- Admin group: `casa_editors` (same as ha-editor ingress).
- NO OAuth2 `groups` scope mapping exists yet (only SAML groups) → created below.
- Certs are Let's Encrypt prod → HA pod can validate authentik TLS without custom CA.
- Domains: SHORT=`<main_home_domain>` (angelnu.com), DOMAIN=`prod.<main_home_domain>`.
  HA URLs: `https://ha.<short>`, `https://ha.pub.<domain>`, `https://ha.home.<domain>`.
  authentik: `https://authentik.pub.<domain>`.
- HA core has a command_line bug (#181437) — keep `args: []` workaround until that
  provider is removed in Phase 5.

================================================================================
PHASE 0 — Safety backup (5 min, browser only)
================================================================================
Open the HA editor UI (ha-editor.pub.prod.angelnu.com) → open a TERMINAL and run:

    cp -a /config/configuration.yaml /config/configuration.yaml.bak-pre-oidc
    cp -a /config/secrets.yaml /config/secrets.yaml.bak-pre-oidc
    tar czf /config/storage-backup-pre-oidc.tgz /config/.storage

.config/.storage holds the user DB (users, refresh tokens, MFA) — this is THE rollback path.
Keep a logged-in admin browser session open throughout; test in a separate incognito window.

================================================================================
PHASE 1 — authentik OIDC provider (Terraform, needs sops+age key + home network)
================================================================================
1) Add client secret to SOPS settings (generate a random 40+ char string):

    sops settings/authentik.yaml
    # add under apps:
    #   home_assistant:
    #     client_secret: "<random-string>"

2) Create `terraform/authentik/app-homeassistant.tf`:

    resource "authentik_property_mapping_provider_scope" "groups" {
      name       = "oauth2-scope-groups"
      scope_name = "groups"
      expression = <<-EOT
    return {
      "groups": [group.name for group in request.user.ak_groups.all()],
    }
    EOT
    }

    resource "authentik_provider_oauth2" "home_assistant" {
      name                   = "home-assistant"
      client_id              = "home-assistant"
      client_secret          = var.authentik_config.apps.home_assistant.client_secret
      sub_mode               = "user_username"
      authentication_flow    = authentik_flow.login.uuid
      authorization_flow     = authentik_flow.authorization_implicit_consent.uuid
      invalidation_flow      = authentik_flow.invalidation.uuid
      property_mappings      = concat(
        data.authentik_property_mapping_provider_scope.oauth2.ids,
        [authentik_property_mapping_provider_scope.groups.id]
      )
      signing_key            = data.authentik_certificate_key_pair.generated.id
      access_token_validity  = "hours=24"
      refresh_token_validity = "days=30"
      allowed_redirect_uris = [
        { matching_mode = "strict", url = "https://ha.${var.cluster_short_domain}/auth/oidc/callback" },
        { matching_mode = "strict", url = "https://ha.pub.${var.cluster_domain}/auth/oidc/callback" },
        { matching_mode = "strict", url = "https://ha.home.${var.cluster_domain}/auth/oidc/callback" },
      ]
    }

    resource "authentik_application" "home_assistant" {
      name              = "Home Assistant"
      slug              = "home-assistant"
      protocol_provider = authentik_provider_oauth2.home_assistant.id
      meta_launch_url   = "https://ha.${var.cluster_short_domain}"
      meta_description  = "Home automation (OIDC SSO)"
    }

    resource "authentik_policy_binding" "home_assistant_app_access" {
      target  = authentik_application.home_assistant.uuid
      group   = authentik_group.groups["default_ingress"].id
      order   = 0
      timeout = 1440
    }

3) Apply from the repo root (machine with sops/age key + VPN/LAN access):

    terraform plan    # expect: scope mapping + provider + application + binding
    terraform apply

4) Verify from the cluster (ssh casa, then):

    kubectl --kubeconfig /tmp/kc-prod.yaml exec -n home-assistant deploy/home-assistant -c main -- \
      curl -s -o /dev/null -w '%{http_code}\n' \
      https://authentik.pub.prod.angelnu.com/application/o/home-assistant/.well-known/openid-configuration
    # expect 200

================================================================================
PHASE 2 — Install the integration (browser, ~5 min + restart)
================================================================================
1) HA UI → HACS → search "OpenID Connect" → install
   "OpenID Connect/SSO Authentication" (christiaangoossens/hass-oidc-auth).
2) Restart: Settings → top-right menu → Restart Home Assistant.
   (homeassistant + command_line providers are still active — no lockout risk.)

================================================================================
PHASE 3 — Configure auth_oidc (editor UI, ~5 min + restart)
================================================================================
1) Add to /config/configuration.yaml (top level):

    auth_oidc:
      client_id: "home-assistant"
      client_secret: !secret authentik_ha_client_secret
      discovery_url: "https://authentik.pub.prod.angelnu.com/application/o/home-assistant/.well-known/openid-configuration"
      display_name: "authentik"
      roles:
        admin: "casa_editors"
      features:
        automatic_user_linking: true   # MIGRATION ONLY — disable in Phase 5

2) Add the secret to /config/secrets.yaml:

    authentik_ha_client_secret: "<same random string as in SOPS>"

3) Restart HA.

================================================================================
PHASE 4 — Verify (incognito + normal session in parallel)
================================================================================
Per user (start with your own account):
1) Incognito → https://ha.prod.angelnu.com (or the ha.pub/ha.home URL) → welcome screen
   shows "Login with authentik" (SSO) + local fallback option.
2) Click SSO → authentik login → redirected back → logged in as the EXISTING HA user
   matching your authentik username (automatic_user_linking links it).
3) Confirm admin rights if in casa_editors; check Settings → People shows the user.
4) Companion app: server URL same https hostname → SSO flow works there too.
   (Direct IP http://192.168.5.130:8123 can still use the local homeassistant login.)
Troubleshooting: HA log lines from custom_components.oidc / auth_oidc; login fallback
URL: https://ha.prod.angelnu.com/?skip_oidc_redirect=true

================================================================================
PHASE 5 — Stabilize & clean up (AFTER all users linked, e.g. 1 week later)
================================================================================
1) Set `features.automatic_user_linking: false` (or remove the features block) → restart.
   Allows forward-only user provisioning; consider also `require_existing_user: true`.
2) Remove the LDAP circumvention from configuration.yaml — delete:

    - type: command_line
      command: /config/ldap-auth.py
      args: []
      meta: true

   (keep `- type: homeassistant` as emergency fallback) → restart.
3) Delete /config/ldap-auth.py (keep the backups *.bak-* for a while).
4) Remove the archived auth_header component: delete /config/custom_components/auth_header
   → restart (clears the "untested custom integration" warning too).
5) Cleanup: rm /config/configuration.yaml.bak-* /config/storage-backup-pre-oidc.tgz when confident.
6) KEEP the authentik LDAP outpost — maddy and tt-rss still authenticate via LDAP.

================================================================================
ROLLBACK (any phase, worst case = full auth restore)
================================================================================
Editor terminal:
    cp -a /config/configuration.yaml.bak-pre-oidc /config/configuration.yaml
    # only if users/tokens damaged:
    rm -rf /config/.storage && tar xzf /config/storage-backup-pre-oidc.tgz -C /
then restart HA. The homeassistant local admin account always works via
?skip_oidc_redirect=true as long as the `homeassistant` provider stays configured.

================================================================================
RUNTIME MATRIX (what to run from the "other machine")
================================================================================
- Phase 0,2,3(edits),4,5: any machine with a browser on LAN/VPN
  (HA UI + ha-editor UI suffice; editor terminal covers all file ops).
- Phase 1: machine with terraform + sops + age key + access to
  https://authentik.pub.prod.angelnu.com (LAN or casa96-all WireGuard).
- Verification kubectl: `ssh casa` (dev host) has kubectl +
  /tmp/kc-prod.yaml (admin, chmod 600; delete after: rm /tmp/kc-prod.yaml).
