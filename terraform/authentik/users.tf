resource "authentik_group" "groups" {
  for_each = var.authentik_groups
  name     = each.key
  is_superuser = lookup(each.value, "is_superuser", false)
}

resource "authentik_user" "users" {
  for_each = var.authentik_users
  username = each.key
  name     = each.value.name
  email    = each.value.email
  groups    = [ for group in each.value.groups : authentik_group.groups[group].id ]
  attributes = jsonencode(lookup(each.value,"attributes",{}))
}