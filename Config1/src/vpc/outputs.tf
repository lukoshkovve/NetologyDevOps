output "network_id" {
  value = yandex_vpc_network.vpc_name.id
}

output "subnet_id" {
  value = yandex_vpc_subnet.subnet_name.id
}