
variable "admin_password" {}
variable "timezone" {
  default = "America/Sao_Paulo"
}
variable "hostname" {}
variable "host_ip" {
  default = "127.0.0.1"
}
variable "volume_path" {
  default = "/opt/nomad/data/pihole"
}