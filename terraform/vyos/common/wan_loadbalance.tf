# The WAN load-balancer (`load-balancing wan`) is intentionally NOT configured.
#
# The load-balancer implementation rewritten in VyOS 1.5-stream/2025.11+ breaks
# the HA failover in two independent ways, both reproduced on VyOS 2026.03:
#
#  1. Per-interface SNAT rules are rendered only for interfaces that own an
#     address at the moment the nftables table is (re)built. VRRP interfaces --
#     which hold the floating address and are the preferred egress when a node
#     is MASTER -- have no address while that node is BACKUP, so their SNAT rule
#     is missing. When the node becomes MASTER, failover traffic egresses the
#     VRRP interface unNATed and is dropped upstream.
#     -> NAT is now handled by `nat_source` (see nat.tf).
#
#  2. The connection mark is restored on ALL interfaces, including the WAN
#     interfaces. Its "exclude local traffic" rule is limited to `ct state new`,
#     so established RETURN traffic destined to the LAN also gets marked and is
#     then routed through the WAN policy table (e.g. `fwmark 0xcb lookup 203`,
#     whose only route is the WAN default) instead of towards the LAN -- the
#     connection silently dies.
#     -> WAN failover is provided by `protocols failover route` (see routes.tf),
#        which installs plain main-table routes with ping health checks and does
#        not mark any packet.
#
# The previous `load_balance_wan` resource is therefore removed. Re-enable it
# only for VyOS releases older than 1.5-stream/2025.11 (its original definition
# is in git history).
