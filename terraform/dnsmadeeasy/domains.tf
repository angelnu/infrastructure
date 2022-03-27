resource "dme_domain" "domains" {
    for_each = local.domains
    name     = each.key
}