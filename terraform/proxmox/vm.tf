resource "proxmox_vm_qemu" "cloudinit-test" {

  for_each = local.vms

  depends_on = [
    linux_file.cloudinit,
  ]

  name        = each.key
  desc        = "tf description"
  target_node = each.value.node
  #qemu_os = 126
  os_type     = "cloud-init"

  agent = 1

  onboot = true

  clone = "Ubuntu-22.04-template-${each.value.node}"

  # The destination resource pool for the new VM
  # pool = "pool0"

  disk {
    // This disk will become scsi0
    type = "scsi"
    storage = "local-lvm"
    size = each.value.boot_disk_size
    ssd = 1
    discard = "on"
  }

  disk {
    // This disk will become scsi1
    type = "scsi"
    storage = ""
    size = each.value.data_disk_size
    volume = each.value.data_disk_volume
    #file = each.value.data_disk_file
    ssd = 1
    discard = "on"
  }

  network {
    bridge    = "vmbr0"
    model     = "virtio"
    macaddr   = local.network_clients_dict[each.key].mac
    #tag       = -1
  }
  
  
  cores   = 4
  sockets = each.value.sockets
  memory  = each.value.memory
  scsihw  = "virtio-scsi-single"

  dynamic hostpci {
   for_each = each.value.hostpci
   content {
    host   = lookup(hostpci.value, "host", null)
    rombar = lookup(hostpci.value, "rombar", null)
    pcie   = lookup(hostpci.value, "pcie", null)
   }
  }

  # os_type   = "cloud-init"
  ciuser = "root"
  # cipassword = "a password"
  sshkeys = join("\n", local.ssh_auth_keys)
  cicustom   = "user=cephfs:snippets/cloudinit_${each.key}.yaml" # cicustom so other ci values ignored

  #ipconfig0 = "ip=10.0.2.99/16,gw=10.0.2.2"
  ipconfig0 = "${each.value.ipconfig0 == null ?
                format("ip=%s/%s,gw=%s", local.network_clients_dict[each.key].ip, var.lan_config.mask_length, var.lan_config.default_router) :
                each.value.ipconfig0 }"

  

}