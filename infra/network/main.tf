terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.90.0"
    }
  }
}

resource "yandex_vpc_network" "vm-network" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "vm-subnet" {
  name           = var.subnet_name
  v4_cidr_blocks = ["192.168.0.0/24"]
  zone           = var.zone
  network_id     = yandex_vpc_network.vm-network.id
}

resource "yandex_vpc_security_group" "vm-network-sg" {
  name = var.sg_name
  network_id = yandex_vpc_network.vm-network.id

  ingress {
    protocol       = "TCP"
    description    = "Allow incoming HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "Allow incoming SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol    = "ANY"
    from_port   = 0
    to_port     = 65535
    predefined_target = "self_security_group"
  }

  egress {
    protocol    = "ANY"
    from_port   = 0
    to_port     = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
