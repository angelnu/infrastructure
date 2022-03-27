resource "authentik_token" "ldap_search_jellyfin" {
  identifier = "jellyfin"
  user = authentik_user.users["ldap"].id
  intent = "app_password"
  retrieve_key = true
  expiring = false
}