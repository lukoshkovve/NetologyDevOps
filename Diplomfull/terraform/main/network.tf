
locals {
  ssh-keys = file("~/.ssh/id_ed25519.pub")
  ssh-private-keys = file("~/.ssh/id_ed25519")
}

#Создаем простую VPC
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

#Создаем подсеть subnet1
resource "yandex_vpc_subnet" "subnet1" {
  name           = var.subnet1
  zone           = var.zone1
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.subnet1_cidr
}

#Создаем подсеть subnet2
resource "yandex_vpc_subnet" "subnet2" {
  name           = var.subnet2
  zone           = var.zone2
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.subnet2_cidr
}
