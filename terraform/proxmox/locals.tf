locals {
    
    test_cluster = {
      memory = 16000
      sockets = 2
      hostpci = []
      boot_disk_size = "50G"
      data_disk_size = "10G"
      data_disk_volume = "/dev/pve/k3s-data-staging"
      data_disk_file = "k3s-data-staging"
      ipconfig0 = "ip=dhcp"
    }
    
    production_cluster = {
      memory = 16000
      sockets = 2
      hostpci = [
        {
          host = "0000:00:02"
        }
      ]
      boot_disk_size = "50G"
      data_disk_size = "50G"
      data_disk_volume = "/dev/pve/k3s-data-production"
      data_disk_file = "k3s-data-staging"
      ipconfig0 = "ip=dhcp"
    }

    vms = {
      "test-k3s1" = merge(
        local.test_cluster,
        {
          node = "pve1"
          ipconfig0 = null
        }
      )
      "test-k3s2" = merge(
        local.test_cluster,
        {
          node = "pve2"
          ipconfig0 = null
        }
      )
      "test-k3s3" = merge(
        local.test_cluster,
        {
          node = "pve3"
          ipconfig0 = null
        }
      )

      "k3s1" = merge(
        local.production_cluster,
        {
          node = "pve1"
          ipconfig0 = null
        }
      )
      "k3s2" = merge(
        local.production_cluster,
        {
          node = "pve2"
          ipconfig0 = null
        }
      )
      "k3s3" = merge(
        local.production_cluster,
        {
          node = "pve3"
          ipconfig0 = null
        }
      )
      "k3s4" = merge(
        local.production_cluster,
        {
          node = "pve4"
          ipconfig0 = null
          hostpci = [
            {
              host = "0000:01:00"
              rombar = 0
            }
          ]
        }
      )
    }

    network_clients_dict = { for i, entry in var.network_clients.hosts: entry.name => entry }

    ssh_auth_keys = [
        trimspace(file(pathexpand("~/.ssh/id_ed25519.pub")))
      ]
}
