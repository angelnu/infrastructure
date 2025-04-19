resource "random_password" "salt" {
  length = 8
}
resource "htpasswd_password" "user_password" {
  password = var.config.default_vm_admin_password
  salt     = random_password.salt.result
}


resource "linux_file" "cloudinit" {

    for_each = local.vms

    path = "/mnt/pve/cephfs/snippets/cloudinit_${each.key}.yaml"
    content = templatefile("${path.module}/cloudinit.tftpl", {
      hostname = each.key
      password = htpasswd_password.user_password.sha512
      ssh_auth_keys: local.ssh_auth_keys
    })
    owner = 0
    group = 0
    mode = "644"
    overwrite = true
    recycle_path = "/tmp/recycle"
}