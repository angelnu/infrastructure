# resource "authentik_token" "ldap_search_maddy" {
#   identifier = "maddy"
#   user = authentik_user.users["ldap_search"].id
#   intent = "app_password"
#   retrieve_key = true
# }