resource "linux_file" "config_dhcp" {
    path = "/etc/config/dhcp"
    content = templatefile("${path.module}/dhcp.tpl", {clients = var.network_clients})
    owner = 0
    group = 0
    mode = "644"
    overwrite = true
    recycle_path = "/tmp/recycle"
}

resource "linux_script" "install_package" {
    lifecycle_commands {
        create = "reload_config"
        read = "/bin/true"
        update = "reload_config"
        delete = "/bin/true"
    }
    sensitive_environment = {
      CONFIG = sha512(resource.linux_file.config_dhcp.content)
    }
}
