variable "archtmpl" {
    default="local:vztmpl/archlinux-base_20201116-1_amd64.tar.gz"
}
variable "debtmpl" {
    default="local:vztmpl/debian-11-standard_11.0-1_amd64.tar.gz"
}
variable "rockt" {
    default="local:vztmpl/rockylinux-8-default_20210929_amd64.tar.xz"
}
variable "ubtmpl" {
    default="local:vztmpl/ubuntu-21.10-standard_21.10-1_amd64.tar.zst"
}
variable "lvmt" {
    default="local-lvm"
}
variable "sshkey" {
    sensitive=true
}
variable "pm_api_token_id" {
    sensitive=true
}
variable "pm_api_token_secret" {
    sensitive=true
}