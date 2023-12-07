# Домашнее задание к занятию "Продвинутые методы работы с Terraform"
**1**.
> Взят необходимый код

> Создана одна ВМ, для этого в файле cloud-init.yml в блоке "module "test-vm" был заменен параметр  instance_count с 2 на 1.
```
module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = "develop"
  network_id      = yandex_vpc_network.develop.id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [ yandex_vpc_subnet.develop.id ]
  instance_name   = "web"
  instance_count  = 1
  image_family    = "ubuntu-2004-lts"
  public_ip       = true

```
>Как в примере, был передан ключ в функцию template_file в блоке vars ={}

cloud-init.yml
```
ssh_authorized_keys:
      - ${ssh_public_key}

```
main.tf
```
data template_file "userdata" {
  template = file("${path.module}/cloud-init.yml")

  vars = {
	ssh_public_key = file("~/.ssh/id_ed25519.pub")
  }
}

```
Для того, чтобы добавить установку nginx, необходимо в блок packages добавить нужный пакет

cloud-init.yml
```

packages:
 - vim
 - nginx

```
РЕЗУЛЬТАТ:
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/4TF/foto/1.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/4TF/foto/2.JPG)

**2**.	
> локальный модуль создан, содержание main.tf, которое создает одну сеть и одну подсеть в необходимой зоне с переменными.

./vpc/main.tf
```
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
```
./vpc/variables.tf
```
variable "env_name" {
  type    = string
}

variable "zone" {
  type    = string
}

variable "cidr" {
  type    = string
}
```
после передачи необходимых параметров сети
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/4TF/foto/4.JPG)

>Файл с документацией находится в корне. Имя doc.md


**3**.	
Вывел список ресурсов

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/4TF/foto/6.JPG)

Удалил модуль vpc

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/4TF/foto/7.JPG)


Удалил модуль vm

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/4TF/foto/8.JPG)

Восстановил все обратно

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/4TF/foto/9.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/4TF/foto/10.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/4TF/foto/11.JPG)