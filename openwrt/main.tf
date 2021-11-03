terraform {
  required_providers {
    linux = {
      source = "TelkomIndonesia/linux"
      version = "0.6.1"
    }
  }
}

provider "linux" {
   host        = "192.168.2.1"
    port     = 22
    user     = "root"
    private_key = file("~/.ssh/id_rsa")
}

resource "linux_file" "file" {
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
      CONFIG = sha512(resource.linux_file.file.content)
    }
}