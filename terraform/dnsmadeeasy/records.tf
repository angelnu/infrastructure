locals {
    domain_records_list = flatten([
        for domain_cfg in var.domains : [
            for record in concat(domain_cfg.records, var.common.common_records): {
                domain = domain_cfg.url
                record = record
            }
        ]
    ])

    domain_records = { for i, entry in local.domain_records_list: "${entry.domain}.${entry.record.type}.${entry.record.name}.${ md5(entry.record.value) }" => entry }
}

resource "dme_dns_record" "records" {
    for_each = local.domain_records

  domain_id     = "${dme_domain.domains[each.value.domain].id}"
  name          = each.value.record.name
  type          = each.value.record.type
  value         = each.value.record.value
  ttl           = lookup(each.value.record, "ttl", var.common.default_ttl)
  mx_level      = lookup(each.value.record, "mx_level", null)
  weight        = lookup(each.value.record, "weight", null)
  dynamic_dns   = lookup(each.value.record, "dynamic_dns", null)
  password      = lookup(each.value.record, "password", null)
  priority      = lookup(each.value.record, "priority", null)
  port          = lookup(each.value.record, "port", null)
#   description   = "First http record"
#   keywords      = "practice record"
#   title         = "record"
#   redirect_type = "Standard - 302"
#   hardlink      = "true"
}