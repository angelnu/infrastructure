resource "vyos_config_block" "ssh_vyos_root_at_dev" {
  path = "system login user vyos authentication public-keys root@dev"
  configs = {
    "type" = "ssh-rsa",
    "key"  = "AAAAB3NzaC1yc2EAAAADAQABAAABgQCjTb+ql6GkNqZSw/fIe6PTDj8nROM8mm6GqMB5BjbbyDWqOb5Uf0Pv/FXOFKcSLCf2l+BGkOuZ4uvRlAS6Z/Rwh3w++Pf2QTfvV8BdoUVN0J2JAvBXqJyipV8u9BkHzsRUZIqRf42s71zZhHloxslwhxVc4HXYJoBFFUN3wzGLsygEhP9Gi4GbPDz11OQ1EuYQruFnFy9RtIk6z8/jLOLbyEnmCWk7jPrO/G/GUjaE5AMPiQr049ht+MyPDh+uhF5Mc7z/Mm82eJmt39GTRmmGMqdZl4046pIxJVseKgxqno3FHz671ZWA7BpUGON4ea4Wo8UFbC+Y+5RV8lAtyfFqyBUzehK2FoHs/Ng0MjGmqWSn0xWD0kjN3braWG5CKpApxhtflD95p6lTicnLnWUqHmGvGQPIGCJI1Ih4vx3l6W56omBJugg3zVibPpI/PBXE4W8LKSFHjl/G2H9Dz4SmnYJfO3F2iRFbeon0+TQ8ddnXf0CTRppr0LTIdgE2biM=",
  }
}

resource "vyos_config_block_tree" "ssh" {
  path = "service ssh"

  configs = {
    "port"      = "22",
    "disable-password-authentication" = "",
  }
}