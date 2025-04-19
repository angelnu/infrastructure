resource "proxmox_vm_qemu" "cloudinit-test" {

  for_each = local.vms

  depends_on = [
    linux_file.cloudinit,
  ]

  name        = each.key
  desc        = "tf description"
  target_node = each.value.node
  #qemu_os = 126
  os_type = "cloud-init"

  agent = 1

  onboot = true

  clone      = "Ubuntu-24.04-template"
  full_clone = true

  # The destination resource pool for the new VM
  # pool = "pool0"

  disks {
    scsi {
      scsi0 {
        disk {
          storage   = "local-lvm"
          size      = each.value.boot_disk_size
          format    = "raw"
          replicate = true

          discard    = true
          emulatessd = true
        }
      }
      scsi1 {
        passthrough {
          #size = each.value.data_disk_size
          file      = each.value.data_disk_volume
          replicate = true

          discard    = true
          emulatessd = true
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id      = 0
    bridge  = "vmbr0"
    model   = "virtio"
    macaddr = local.network_clients_dict[each.key].mac
    #tag       = -1
  }

  serial {
    id   = 0
    type = "socket"
  }

  cores   = 4
  sockets = each.value.sockets
  memory  = each.value.memory
  scsihw  = "virtio-scsi-single"

  dynamic "pci" {
    for_each = each.value.pci
    content {
      id     = pci.key
      raw_id = lookup(pci.value, "raw_id", null)
      rombar = lookup(pci.value, "rombar", true)
      pcie   = lookup(pci.value, "pcie", false)
    }
  }

  # os_type   = "cloud-init"
  ciuser = "root"
  # cipassword = "a password"
  sshkeys  = join("\n", local.ssh_auth_keys)
  cicustom = "user=cephfs:snippets/cloudinit_${each.key}.yaml" # cicustom so other ci values ignored

  #ipconfig0 = "ip=10.0.2.99/16,gw=10.0.2.2"
  ipconfig0 = (each.value.ipconfig0 == null ?
    format("ip=%s/%s,gw=%s", local.network_clients_dict[each.key].ip, var.lan_config.mask_length, var.lan_config.vrrp.ip) :
  each.value.ipconfig0)



}