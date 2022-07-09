# terraform-nomad-pihole

```
provider nomad {
    address = "http://192.168.15.6:4646"
    region  = "global"
}
```

```
module "pihole" {
    source = "github.com/ckrst/terraform-nomad-pihole?ref=v0.0.1"

    admin_password = "admin"
    timezone = "America/Sao_Paulo"
    hostname = "chico"
    host_ip = "192.168.15.6"
    volume_path = "/opt/nomad/data/pihole"
}
```
