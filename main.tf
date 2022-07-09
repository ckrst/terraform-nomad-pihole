
resource "nomad_job" "pihole" {
  hcl2 {
    enabled = true
    vars = {
      "datacenters"  = "[\"dc1\"]",
      admin_password = var.admin_password,
      timezone       = var.timezone,
      hostname       = var.hostname,
      ip_addr        = var.host_ip,
      volume_path    = var.volume_path,
    }
  }

  jobspec = <<EOT

variable "datacenters" {
    type = list(string)
}

variable "admin_password" {
    type = string
}

variable "timezone" {
    type = string
}

variable "hostname" {
    type = string
}

variable "ip_addr" {
    type = string
}

variable "volume_path" {
    type = string
}

job "pihole" {
    region = "global"
    datacenters = var.datacenters
    type = "service"
    group "svc" {
        count = 1
        restart {
            attempts = 5
            delay    = "15s"
        }
        task "app" {
            driver = "docker"
            config {
                image = "pihole/pihole:latest"
                volume_mount {
                    volume      = "pihole-data"
                    destination = "/etc/pihole"
                    read_only   = false
                }
                volume_mount {
                    volume      = "dns-data"
                    destination = "/etc/dnsmasq.d"
                    read_only   = false
                }
                port_map {
                    dns  = 53
                    http = 80
                }
                dns_servers = [
                    "127.0.0.1",
                    "1.1.1.1",
                ]
            }
            env = {
                "TZ"           = var.timezone
                "WEBPASSWORD"  = var.admin_password
                "DNS1"         = "8.8.8.8"
                "DNS2"         = "no"
                "INTERFACE"    = "eth0"
                "VIRTUAL_HOST" = var.hostname
                "ServerIP"     = var.ip_addr
            }
            resources {
                cpu    = 100
                memory = 128
                network {
                    port "dns" {
                        static = 53
                    }
                    port "http" {}
                }
            }
            service {
                name = "pihole-gui"
                port = "http"
            }
        }
    }
}
EOT
}