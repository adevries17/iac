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
  content = templatefile("${abspath(path.root)}/templates/ansible-inventory.tpl", {
    dingusfactory    = [for host in proxmox_vm_qemu.dingusfactory.* : "${host.name}"]
    dingusfactorylxc = [for host in proxmox_lxc.dingusfactorylxc.* : "${host.hostname}"]
    arkabtc          = [for host in proxmox_lxc.arkabtc.* : "${host.hostname}"]
  })
  filename = "${dirname(abspath(path.root))}/ansible/inventory.ini"
}
# vms
resource "proxmox_vm_qemu" "dingusfactory" {
  ciuser      = "toog"
  count       = 1
  name        = "dingusfactory-${count.index + 1}"
  target_node = "tnpve2"
  clone       = "cent9-tpl"
  agent       = 1
  os_type     = "cloud-init"
  cores       = 4
  sockets     = 1
  cpu         = "host"
  memory      = 16384
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  onboot      = true
  disk {
    slot     = 0
    size     = "16G"
    type     = "scsi"
    storage  = "tnnaspve"
    iothread = 1
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  ipconfig0 = "ip=192.168.17.101/24,gw=192.168.17.1"
  sshkeys   = var.sshkey
}
# containers
resource "proxmox_lxc" "dingusfactorylxc" {
  cores           = 4
  hostname        = "dingusfactory"
  memory          = 16384
  onboot          = true
  ostemplate      = var.ubuntu2204
  ssh_public_keys = var.sshkey
  start           = true
  target_node     = "tnpve2"
  unprivileged    = true
  vmid            = 115
  network {
    bridge = "vmbr0"
    gw     = "192.168.17.1"
    ip     = "192.168.17.115/24"
    name   = "eth0"
  }
  rootfs {
    size    = "16G"
    storage = "tnnaspve"
  }
}
resource "proxmox_lxc" "arkabtc" {
  cores           = 6
  hostname        = "arkabtc"
  memory          = 16384
  onboot          = true
  ostemplate      = var.ubuntu2204
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
    size    = "32G"
    storage = "tnnaspve"
  }
}
