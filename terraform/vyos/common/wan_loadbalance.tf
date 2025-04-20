resource "vyos_config_block_tree" "load_balance_wan" {
  path = "load-balancing wan"
  configs = merge(

    merge([
      for delta, interface in flatten(concat(
        [
          for network in var.config.networks : [
            network.device,
            format("%s%s", network.device, network.vrrp.nic_suffix)
          ]
        ],
        [
          var.config.wireguard.device,
          "lo"
        ]
      )) :
      merge(
        {
          # Exclude Multicast traffic (such as VRRP)
          "rule ${3 * delta + 1} description"         = "Exclude multicast traffic"
          "rule ${3 * delta + 1} exclude"             = ""
          "rule ${3 * delta + 1} inbound-interface"   = interface
          "rule ${3 * delta + 1} destination address" = "224.0.0.0/4"
          "rule ${3 * delta + 1} protocol"            = "all"

          # Exclude local traffic
          "rule ${3 * delta + 2} description"         = "Exclude multicast traffic"
          "rule ${3 * delta + 2} exclude"             = ""
          "rule ${3 * delta + 2} inbound-interface"   = interface
          "rule ${3 * delta + 2} destination address" = "192.168.0.0/16"
          "rule ${3 * delta + 2} protocol"            = "all"

          # Load balance all the remaining traffic arriving via the lan
          "rule ${3 * delta + 3} inbound-interface" = interface,
          "rule ${3 * delta + 3} failover"          = "",
          "rule ${3 * delta + 3} protocol"          = "all"
        },
        { for interface, weight in
          merge(
            [for network_name, network in var.config.networks :
              {
                "${network.device}" : 10 - network.priority
                "${network.device}${network.vrrp.nic_suffix}" : 20 - network.priority
              } if network.zone == "wan"
            ]...
          ) :
          "rule ${3 * delta + 3} interface ${interface} weight" => weight
        }
      )
    ]...),

    merge(flatten(
      # Loop networks of type WAN
      [for network_name, network in var.config.networks :
        # 2 devices per network: itself and its vrrp
        [for device in [network.device, format("%s%s", network.device, network.vrrp.nic_suffix)] :
          [
            {
              # Health rules for device
              "interface-health ${device} nexthop"       = network.nexthop
              "interface-health ${device} failure-count" = "2"
              "interface-health ${device} success-count" = "2" # wait before switching back
            },
            [for id, target in var.config.ping_test_ips :
              {
                # Health checks for NIC - pings
                "interface-health ${device} test ${id} resp-time" = "5"
                "interface-health ${device} test ${id} ttl-limit" = "1"
                "interface-health ${device} test ${id} target"    = target
              }
            ]
          ]
        ] if network.zone == "wan"
      ]
    )...),
    {
      "flush-connections" = "", #Problem with https://phabricator.vyos.net/T1311
      #"enable-local-traffic" = "" #it uses mange to change the output - order is default route table -> output table (mangle) to mark packages -> dedicated
    }

  )
  timeouts {
    create  = "60m"
    update  = "60m"
    delete  = "60m"
    default = "60m"
  }
  depends_on = [
    vyos_config_block_tree.eth0,
    vyos_config_block_tree.eth1
  ]
}
