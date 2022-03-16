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
resource "proxmox_lxc" "rockmc-0" {
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
    
}
resource "proxmox_lxc" "satisfactory" {
    count           = 0
    cores           = 6
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
    vmid            = 111
    network {
        bridge      = "vmbr0"
        gw          = "192.168.17.1"
        ip          = "192.168.17.111/24"
        name        = "eth0"
    }
    rootfs {
        size        = "32G"
        storage     = var.lvmt
    }
}