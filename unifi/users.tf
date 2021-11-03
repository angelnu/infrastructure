locals {
  users    = { for user in var.network_clients : user.mac => user if user.mac != ""}
}

resource "unifi_user" "user" {
  for_each = local.users

  mac  = each.key
  name = each.value.name
  
  #Disabled -> requires an Unifi gateway
  #fixed_ip = each.value.ip != "" ? each.value.ip : null
  
  # append an optional additional note
  note = trimspace("${each.value.note}\n\nmanaged by TF")

  allow_existing         = true
  skip_forget_on_destroy = false
}