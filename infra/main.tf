# terraform init -backend-config="access_key=$(cat yandex-s3.json | jq -r .access_key)" -backend-config="secret_key=$(cat yandex-s3.json | jq -r .secret_key)"
locals {
    cloud_id  = "b1g27vf45j3ju5976tkl"
    folder_id = "b1g5sejtlu2jduscaqk4"
    zone      = "ru-central1-d"

    network_name = "itmo508541-sem2-vm-network"
    subnet_name  = "itmo508541-sem2-vm-subnet"
    sg_name   = "itmo508541-sem2-vm-sg"
    vm_name      = "itmo508541-sem2-vm-docker"
}

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.90.0"
    }
  }

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    bucket = "itmo508541-tf-state"
    region = "ru-central1"
    key    = "sem2/vm-kittigram/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  service_account_key_file = "yandex-sa.json"
  cloud_id  = local.cloud_id
  folder_id = local.folder_id
  zone      = local.zone
}

module "network" {
  source       = "./network"
  zone         = local.zone
  network_name = local.network_name
  subnet_name  = local.subnet_name
  sg_name = local.sg_name
}

module "docker" {
    source = "./docker"
    ubuntu_image_id = "fd83ica41cade1mj35sr"
    vm_platform_id  = "standard-v3"
    subnet_id       = module.network.subnet_id
    vm_name         = local.vm_name
    sg_id           = module.network.sg_id
}

resource "local_file" "tests_yml" {
  content = yamlencode({
    repo_owner = "itmo-508541"
    kittygram_domain = format("http://%s/", module.docker.vm-external-ip)
    dockerhub_username: "itmo508541"
  })
  filename = "../tests.yml"
}

resource "local_file" "deployment_info" {
  content = jsonencode({
    host = module.docker.vm-external-ip
    user = "runner"
  })
  filename = "../deployment.json"
}