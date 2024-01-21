terraform {
  required_providers {
	yandex = {
  	source = "yandex-cloud/yandex"
	}
  }
  required_version = ">=0.13"
}
#Создаем сеть
resource "yandex_vpc_network" "vpc_name" {
  name = var.env_name
}

#Создаем подсеть
resource "yandex_vpc_subnet" "subnet_name" {
  name       	= "${var.env_name}-${var.zone}"
  zone       	= var.zone
  network_id 	= yandex_vpc_network.vpc_name.id
  v4_cidr_blocks = [var.cidr]
}