resource "vyos_config_block_tree" "podman_container_network" {
  path = "container network ${var.config.containers.network.name}"

  configs = {
    description : "Default network for container"
    prefix : var.config.containers.network.cidr
  }
  depends_on = [
    vyos_config_block_tree.eth0
  ]
}