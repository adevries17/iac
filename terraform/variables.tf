variable "lvmt" {
  default = "local-lvm"
}

# nas templates
variable "rocky8" {
  default = "tnnaspve:vztmpl/rockylinux-8-default_20210929_amd64.tar.xz"
}
variable "ubuntu2204" {
  default = "tnnaspve:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
}

variable "sshkey" {
  sensitive = true
}
variable "pm_api_token_id" {
  sensitive = true
}
variable "pm_api_token_secret" {
  sensitive = true
}
