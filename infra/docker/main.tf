terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.90.0"
    }
  }
}

resource "yandex_compute_instance" "vm" {
  name = var.vm_name
  platform_id = var.vm_platform_id

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
    security_group_ids = [ var.sg_id ]
  }

  metadata = {
    user-data = "${file("./user-data.yaml")}"
  }
}

output "vm-external-ip" {
  value = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}
