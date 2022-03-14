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
resource "proxmox_lxc" "rockmc-0" {
    count=1
    target_node="vmtoog"
    hostname="gunnermc"
    ostemplate=var.rockt
    unprivileged=true
    onboot=true
    start=true
    vmid=150
    cores=8
    memory=24576
    rootfs {
        storage=var.lvmt
        size="8G"
    }
    network {
        name="eth0"
        bridge="vmbr0"
        ip="192.168.17.150/24"
        gw="192.168.17.1"
    }
    ssh_public_keys=var.sshkey
}