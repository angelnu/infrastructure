resource "dme_domain" "domains" {
    for_each = var.domains
    name     = each.key
}