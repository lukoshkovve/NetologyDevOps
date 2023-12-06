# Домашнее задание к занятию "Управляющие конструкции в коде Terraform"
**1**.
> Проект изучен.

> Файл personal.auto.tfvars заполнен.

>Код выполнен.

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/TF3/foto/1.JPG)

**2**.	

1. Создан файл count-vm.tf
```
resource "yandex_compute_instance" "web" {
  count = 2
  name = "develop-web-${count.index + 1}"
  resources {
        cores           = 2
        memory          = 1
        core_fraction = 5
  }
  boot_disk {
        initialize_params {
        image_id = "fd84sckatqc1mapbpt9h"
        }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat       = true
  }  
  
  metadata = {
        ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
```
Созданы виртуальные машины:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/TF2/foto/2.JPG)

Установлена группа безопасности:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/TF2/foto/3.JPG)

2.Создал файл for_each-vm.tf
```
resource "yandex_compute_instance" "f_each" {
  depends_on = [yandex_compute_instance.web]
  for_each = {
    main = var.each_vm[0]
    replica = var.each_vm[1]
  }
  name        = "${each.key}"
  platform_id = "standard-v1"
  resources {
    cores         = "${each.value.cpu}"
    memory        = "${each.value.ram}"
    core_fraction = "${each.value.fraction}"  
}
  boot_disk {
    initialize_params {
      image_id = "fd84sckatqc1mapbpt9h"
      type = "network-hdd"
      size = "${each.value.disk}"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys           = local.ssh-keys
  }

}

```
Переменные
```
variable "each_vm" {
  type = list(object({ vm_name=string, cpu=number, ram=number, disk=number, fraction=number }))
  default = [
    { vm_name=0, cpu=2, ram=2, disk=8, fraction=5 },
    { vm_name=1, cpu=4, ram=4, disk=10, fraction=20 }
  ]
}
```
3. Ресурсы создаются после (web)
```
depends_on = [yandex_compute_instance.web]
```
4. Локальная переменная
```
locals {
  ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
}
```
5. После выполнения кода, все ВМ создались корректно и в правильной последовательности

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/TF3/foto/4.JPG)

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/TF3/foto/5.JPG)

**3**.	
Создадим файл disk_vm.tf с содержимым
```
resource "yandex_compute_disk" "hdd_vmachine" {
  count = 3
  name = "${"disk"}-${count.index + 1}"
  size = 1
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  depends_on = [yandex_compute_disk.hdd_vmachine]
  platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = "fd84sckatqc1mapbpt9h"
    }
  }
  dynamic "secondary_disk" {
   for_each = "${yandex_compute_disk.hdd_vmachine.*.id}"
   content {
 	disk_id = yandex_compute_disk.hdd_vmachine["${secondary_disk.key}"].id
   }
}

network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys           = local.ssh-keys
  }

}
```
Результат исполнения

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/TF3/foto/6.JPG)

Итог
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/TF3/foto/7.JPG)


**4**.	

Взял готовый код из демонстрации к лекции для ansible.tf
```
resource "local_file" "inventory_cfg" {
  content = templatefile("${path.module}/ansible.tftpl",
	{
  	webservers	= yandex_compute_instance.web,
  	databases   = yandex_compute_instance.f_each,
  	storage = [yandex_compute_instance.storage]
	}
  )

  filename = "${abspath(path.module)}/inventory.yml"
}
```
так же взял шаблон из лекции для  ansible.tftpl

```
[webservers]
%{ for i in webservers }
${i["name"]} ansible_host=${i["network_interface"][0]["nat_ip_address"]}
%{ endfor }

[databases]
%{ for i in databases }
${i["name"]} ansible_host=${i["network_interface"][0]["nat_ip_address"]}
%{ endfor }

[storage]
%{ for i in storage }
${i["name"]} ansible_host=${i["network_interface"][0]["nat_ip_address"]}
%{ endfor }
```
 Выполняем код
 ![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/TF3/foto/8.JPG)

 Файл inventory.yml
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/TF3/foto/8.JPG)

Проверяем на одной из виртуалок, что nginx установлен
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/TF3/foto/10.JPG)