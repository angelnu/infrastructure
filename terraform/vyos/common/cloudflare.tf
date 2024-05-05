resource "vyos_config_block_tree" "cloudflare_container" {
  path = "container name cloudflare"

  configs = {
    image: "docker.io/cloudflare/cloudflared:latest"
    command: "tunnel --no-autoupdate run --token ${var.config.cloudflare.token}"
    "network ${var.config.containers.network.name}": ""
  }
  depends_on = [
    vyos_config_block_tree.eth0,
    vyos_config_block_tree.podman_container_network
  ]
}