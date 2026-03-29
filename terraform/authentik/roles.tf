resource "authentik_rbac_role" "roles" {
  for_each = {
    ldap_search : "LDAP Search Role"
  }
  name = each.value
}

# ldap_search
resource "authentik_rbac_permission_role" "ldap_provider_search_perm" {
  role       = authentik_rbac_role.roles["ldap_search"].id
  model      = "authentik_providers_ldap.ldapprovider"
  permission = "search_full_directory"
  object_id  = authentik_provider_ldap.ldap_app.id # Your LDAP Provider ID
}
