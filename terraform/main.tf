terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.4"
    }
  }
}
provider "proxmox" {
  pm_api_url          = "https://tnpve1.turtlesnet.dev:8006/api2/json"
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
}
# ansible inventory
resource "local_file" "ansible_inventory" {
  content  = templatefile("${abspath(path.root)}/templates/ansible-inventory.tpl", { factorygame = [for host in proxmox_lxc.factorygame.* : "${host.hostname}"], minecraft = [for host in proxmox_lxc.minecraft.* : "${host.hostname}"], valheim = [for host in proxmox_lxc.valheim.* : "${host.hostname}"] })
  filename = "${dirname(abspath(path.root))}/ansible/inventory.ini"
}
# containers
resource "proxmox_lxc" "factorygame" {
  count           = 2
  cores           = 4
  hostname        = "factorygame-${count.index + 1}"
  memory          = 16384
  onboot          = true
  ostemplate      = var.rockt
  ssh_public_keys = var.sshkey
  start           = true
  target_node     = "tnpve1"
  unprivileged    = true
  network {
    bridge = "vmbr0"
    gw     = "192.168.17.1"
    ip     = "dhcp"
    name   = "eth0"
  }
  rootfs {
    size    = "16G"
    storage = var.lvmt
  }
}
resource "proxmox_lxc" "minecraft" {
  count           = 0
  cores           = 4
  hostname        = "minecraft-${count.index + 1}"
  memory          = 12288
  onboot          = true
  ostemplate      = var.rockt
  ssh_public_keys = var.sshkey
  start           = true
  target_node     = "tnpve2"
  unprivileged    = true
  network {
    bridge = "vmbr0"
    gw     = "192.168.17.1"
    ip     = "dhcp"
    name   = "eth0"
  }
  rootfs {
    size    = "12G"
    storage = var.lvmt
  }
}
resource "proxmox_lxc" "testbox" {
  count           = 1
  cores           = 4
  hostname        = "testbox-${count.index + 1}"
  memory          = 4096
  onboot          = true
  ostemplate      = var.ubtmpl
  ssh_public_keys = var.sshkey
  start           = true
  target_node     = "tnpve2"
  unprivileged    = true
  network {
    bridge = "vmbr0"
    gw     = "192.168.17.1"
    ip     = "dhcp"
    name   = "eth0"
  }
  rootfs {
    size    = "8G"
    storage = var.lvmt
  }
}
resource "proxmox_lxc" "valheim" {
  count           = 1
  cores           = 2
  hostname        = "valheim-${count.index + 1}"
  memory          = 4096
  onboot          = true
  ostemplate      = var.rocky8
  ssh_public_keys = var.sshkey
  start           = true
  target_node     = "tnpve2"
  unprivileged    = true
  network {
    bridge = "vmbr0"
    gw     = "192.168.17.1"
    ip     = "dhcp"
    name   = "eth0"
  }
  rootfs {
    size    = "8G"
    storage = var.lvmt
  }
}
