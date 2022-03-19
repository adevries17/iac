terraform {
    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "2.9.4"
        }
    }
}
provider "proxmox" {
    pm_api_url          = "https://tnpve1.turtlesnet.dev:8006/api2/json"
    pm_api_token_id     = var.pm_api_token_id
    pm_api_token_secret = var.pm_api_token_secret
}

# resources
resource "proxmox_lxc" "factorygame" {
    count           = 2
    cores           = 4
    hostname        = "factorygame-${count.index+1}"
    memory          = 12288
    onboot          = true
    ostemplate      = var.rockt
    protection      = false
    ssh_public_keys = var.sshkey
    start           = true
    swap            = 512
    target_node     = "tnpve1"
    unprivileged    = true
    network {
        bridge      = "vmbr0"
        gw          = "192.168.17.1"
        ip          = "dhcp"
        name        = "eth0"
    }
    rootfs {
        size        = "16G"
        storage     = var.lvmt
    }
}
resource "proxmox_lxc" "minecraft" {
    count           = 1
    cores           = 4
    hostname        = "minecraft-${count.index+1}"
    memory          = 16384
    onboot          = true
    ostemplate      = var.rockt
    protection      = false
    ssh_public_keys = var.sshkey
    start           = true
    swap            = 512
    target_node     = "tnpve1"
    unprivileged    = true
    network {
        bridge      = "vmbr0"
        gw          = "192.168.17.1"
        ip          = "dhcp"
        name        = "eth0"
    }
    rootfs {
        size        = "12G"
        storage     = var.lvmt
    }
}
resource "local_file" "ansible_inventory" {
    content = templatefile("${abspath(path.root)}/templates/ansible-inventory.tpl", { factorygame=[for host in proxmox_lxc.factorygame.*: "${host.hostname}.turtlesnet.dev"], minecraft=[for host in proxmox_lxc.minecraft.*: "${host.hostname}.turtlesnet.dev"] })
    filename = "${dirname(abspath(path.root))}/ansible/inventory.ini"
}

/*resource "proxmox_lxc" "rockmc-0" {
    count           = 1
    cores           = 8
    hostname        = "gunnermc"
    memory          = 24576
    onboot          = true
    ostemplate      = var.rockt
    protection      = false
    ssh_public_keys = var.sshkey
    start           = true
    swap            = 512
    target_node     = "vmtoog"
    unprivileged    = true
    vmid            = 150
    network {
        bridge      = "vmbr0"
        gw          = "192.168.17.1"
        ip          = "192.168.17.150/24"
        name        = "eth0"
    }
    rootfs {
        size        = "8G"
        storage     = var.lvmt
    }

} */