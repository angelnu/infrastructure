resource "vyos_config_block_tree" "load_balance_wan" {
  path = "load-balancing wan"
  configs = merge(
    
     merge([      
      for delta, interface in [var.config.networks.lan.device, var.config.wireguard.device, "lo"]: 
      {
        # Exclude Multicast traffic (such as VRRP)
        "rule ${10  + delta} description"         = "Exclude multicast traffic"
        "rule ${10  + delta} exclude"             = ""
        "rule ${10  + delta} inbound-interface"   = interface
        "rule ${10  + delta} destination address" = "224.0.0.0/4"
        "rule ${10  + delta} protocol"            = "all"

        # Exclude local traffic
        "rule ${20  + delta} description"         = "Exclude multicast traffic"
        "rule ${20  + delta} exclude"             = ""
        "rule ${20  + delta} inbound-interface"   = interface
        "rule ${20  + delta} destination address" = "192.168.0.0/16"
        "rule ${20  + delta} protocol"            = "all"
        
        # Load balance all the remaining traffic arriving via the lan
        "rule ${100 + delta} inbound-interface"   = interface,
        "rule ${100 + delta} failover"            = "",
        "rule ${100 + delta} interface ${var.config.networks.fritzbox.device}${var.config.vrrp.nic_suffix} weight"= "100",
        "rule ${100 + delta} interface ${var.config.networks.fritzbox.device} weight"= "10",
        "rule ${100 + delta} interface ${var.config.networks.lte.device} weight"= "1",
        "rule ${100 + delta} protocol"            = "all"
      }
    ]...),

    {
      "interface-health ${var.config.networks.fritzbox.device}${var.config.vrrp.nic_suffix} nexthop" = var.config.networks.fritzbox.nexthop
      "interface-health ${var.config.networks.fritzbox.device}${var.config.vrrp.nic_suffix} failure-count" = "1"
      "interface-health ${var.config.networks.fritzbox.device}${var.config.vrrp.nic_suffix} success-count"    = "10" # wait before switching back
      "interface-health ${var.config.networks.fritzbox.device}${var.config.vrrp.nic_suffix} test 0 resp-time" = "5"
      "interface-health ${var.config.networks.fritzbox.device}${var.config.vrrp.nic_suffix} test 0 ttl-limit" = "1"
      "interface-health ${var.config.networks.fritzbox.device}${var.config.vrrp.nic_suffix} test 1 resp-time" = "5"
      "interface-health ${var.config.networks.fritzbox.device}${var.config.vrrp.nic_suffix} test 1 ttl-limit" = "1"
      "interface-health ${var.config.networks.fritzbox.device} nexthop" = var.config.networks.fritzbox.nexthop
      "interface-health ${var.config.networks.fritzbox.device} failure-count" = "1"
      "interface-health ${var.config.networks.fritzbox.device} success-count"    = "10" # wait before switching back
      "interface-health ${var.config.networks.fritzbox.device} test 0 resp-time" = "5"
      "interface-health ${var.config.networks.fritzbox.device} test 0 ttl-limit" = "1"
      "interface-health ${var.config.networks.fritzbox.device} test 1 resp-time" = "5"
      "interface-health ${var.config.networks.fritzbox.device} test 1 ttl-limit" = "1"
      "interface-health ${var.config.networks.lte.device     } nexthop" = var.config.networks.lte.nexthop
      "interface-health ${var.config.networks.lte.device     } failure-count" = "1"
      "interface-health ${var.config.networks.lte.device     } success-count"    = "10"
      "interface-health ${var.config.networks.lte.device     } test 0 resp-time" = "5"
      "interface-health ${var.config.networks.lte.device     } test 0 ttl-limit" = "1"
      "interface-health ${var.config.networks.lte.device     } test 1 resp-time" = "5"
      "interface-health ${var.config.networks.lte.device     } test 1 ttl-limit" = "1"
    },
    {
      for id, target in var.config.ping_test_ips : "interface-health ${var.config.networks.fritzbox.device} test ${id} target" => target
    },
    {
      for id, target in var.config.ping_test_ips : "interface-health ${var.config.networks.fritzbox.device}${var.config.vrrp.nic_suffix} test ${id} target" => target
    },
    {
      for id, target in var.config.ping_test_ips : "interface-health ${var.config.networks.lte.device     } test ${id} target" => target
    },
    {
      "flush-connections" = "", #Problem with https://phabricator.vyos.net/T1311
      #"enable-local-traffic" = "" #it uses mange to change the output - order is default route table -> output table (mangle) to mark packages -> dedicated
    }

  )
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
    default = "60m"
  }
  depends_on = [
    vyos_config_block_tree.eth0,
    vyos_config_block_tree.eth1
  ]
}
