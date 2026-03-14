output "network_id" {
  value = yandex_vpc_network.vm-network.id
}

output "subnet_id" {
  value = yandex_vpc_subnet.vm-subnet.id
}

output "sg_id" {
  value = yandex_vpc_security_group.vm-network-sg.id
}
