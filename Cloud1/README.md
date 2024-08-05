# Домашнее задание к занятию «Организация сети»

**Задание 1:**

>Создадим пустую VPC

<details><summary>networkvpc.tf</summary>

```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}

#Создаем простую VPC
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
```
</details>


>Так же подготовим файл с переменными:


<details><summary>variables.tf</summary>

```
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC"
}
```
</details>

После применения, у нас появилась сеть develop

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud1/foto/1.JPG)

**Задание 2-3:**

Дополним networkvpc.tf необходимымы подсетями

<details><summary>networkvpc.tf</summary>

```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

locals {
  ssh-keys = file("~/.ssh/id_ed25519.pub")
  ssh-private-keys = file("~/.ssh/id_ed25519")
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}

#Создаем простую VPC
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

#Создаем подсеть public
resource "yandex_vpc_subnet" "public" {
  name           = var.public_subnet
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.public_cidr
}

#Создаем подсеть private
resource "yandex_vpc_subnet" "private" {
  name           = var.private_subnet
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.private_cidr
  route_table_id = yandex_vpc_route_table.route.id
}

#https://terraform-provider.yandexcloud.net/Resources/vpc_route_table возьмем отсюда управление таблицей маршрутизации

resource "yandex_vpc_route_table" "route" {
  name       = "route"
  network_id = yandex_vpc_network.develop.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}
```

</details>


Добавим в еще переменные для подсети в наш файл с переменными

<details><summary>variables.tf</summary>

```
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC"
}

variable "public_subnet" {
  type        = string
  default     = "public"
  description = "subnet name"
}

variable "private_subnet" {
  type        = string
  default     = "private"
  description = "subnet name"
}

variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

```
</details>

>В результате у нас две подсети с правилом route

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud1/foto/2.JPG)

Далее создаем instance

<details><summary>instance_nat.tf</summary>

```
resource "yandex_compute_instance" "nat" {
  name = "nat"
  platform_id       = "standard-v1"

  resources {
    cores           = 2
    memory          = 1
    core_fraction   = 5
  }
  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    nat        = true
    ip_address = "192.168.10.254"
  }
   
  scheduling_policy {
    preemptible = true
  }
  metadata = {
    ssh-keys = "ubuntu:${local.ssh-keys}"
    serial-port-enable = "1"
  }
}
```
</details>


<details><summary>instance_public.tf</summary>

```
resource "yandex_compute_instance" "public" {
  name = "public"
  platform_id       = "standard-v1"

  resources {
    cores           = 2
    memory          = 1
    core_fraction   = 5
  }
  boot_disk {
    initialize_params {
      image_id = "fd8idfolcq1l43h1mlft"
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    nat        = true
  }
   
  scheduling_policy {
    preemptible = true
  }
  metadata = {
    ssh-keys = "ubuntu:${local.ssh-keys}"
    serial-port-enable = "1"
  }
}

```
</details>


В инстансе private необходимо прописать ssh от public для доступа непосредственно с последнего

<details><summary>instance_private.tf</summary>

```
resource "yandex_compute_instance" "private" {
  name = "private"
  platform_id       = "standard-v1"

  resources {
    cores           = 2
    memory          = 1
    core_fraction   = 5
  }
  boot_disk {
    initialize_params {
      image_id = "fd8idfolcq1l43h1mlft"
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.private.id
    nat        = false
  }
   
  scheduling_policy {
    preemptible = true
  }
  metadata = {
    ssh-keys = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKbDkAW3dAp2ZENjp2AJflMseGewC7/z4iNkoHrEhE2l ubuntu@fhm9mdp97s28reg2fd7q"
    serial-port-enable = "1"
  }
}

```
</details>

>После применения все 3 инстанса созданы

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud1/foto/3.JPG)


Проверяем доступность с инстанса private ресурс ya.ru с включенным инстансом nat

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud1/foto/4.JPG)

И с выключенным инстансом nat

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud1/foto/5.JPG)

Все работает как надо.