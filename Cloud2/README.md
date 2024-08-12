# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»

**Задание 1:**

>Обратимся к официальной документации по созданию бакета https://yandex.cloud/ru/docs/storage/operations/buckets/create#tf_1


<details><summary>backet.tf</summary>

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

// Создание сервисного аккаунта
resource "yandex_iam_service_account" "sa" {
  name = "netologycloud"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "lukoshkov" {
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = "lukoshkov"
  acl    = "public-read"
}

// Загрузка в бакет картинки
resource "yandex_storage_object" "picture" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "lukoshkov"
  key    = "picture.jpg"
  source = "~/picture.jpg"
  acl = "public-read"
  depends_on = [yandex_storage_bucket.lukoshkov]
}

```
</details>


После выполнения кода у нас создался bucket с именем lukoshkov и файл доступен из интернет.

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud2/foto/1.JPG)

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud2/foto/2.JPG)

2. Создаем группу ВМ а так же проверку состояния.

<details><summary>vmgroup.tf</summary>

```
resource "yandex_iam_service_account" "vmgroup" {
  name        = "vmgroup"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id  = var.folder_id
  role       = "admin"
  member     = "serviceAccount:${yandex_iam_service_account.vmgroup.id}"
  depends_on = [
    yandex_iam_service_account.vmgroup,
  ]
}

resource "yandex_compute_instance_group" "vmgroups" {
  name = "public"
  folder_id           = var.folder_id
  deletion_protection = false
  depends_on          = [yandex_resourcemanager_folder_iam_member.editor]
  service_account_id  = yandex_iam_service_account.vmgroup.id
  instance_template {
    platform_id       = "standard-v1"
  
    resources {
    cores           = 2
    memory          = 1
    core_fraction   = 5
  }
  boot_disk {
    initialize_params {
      image_id = "fd827b91d99psvq5fjit"
    }
  }
  network_interface {
    subnet_ids  = [yandex_vpc_subnet.public.id]
  }
   
  scheduling_policy {
    preemptible = true
  }
  metadata = {
    ssh-keys = "ubuntu:${local.ssh-keys}"
    serial-port-enable = "1"
    user-data = file("index.yaml")
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

   health_check {
    interval = 60
    timeout  = 30
    tcp_options {
      port = 80
    }
  }
}  
```

</details>

Проверяем, группа с необходимыми ВМ создалась. 

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud2/foto/3.JPG)

Как и теребовалось, в user-data создали стартовую страницу с содержимым:

```
#cloud-config
runcmd:
  - [ sh, -c, "echo '<img src='https://storage.yandexcloud.net/lukoshkov/picture.jpg'>' > /var/www/html/index.html" ]
```
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud2/foto/4.JPG)

4. По заданию подключим группу к сетевому балансировщику воспользуемся официальной документацией от яндекса https://yandex.cloud/ru/docs/network-load-balancer/operations/load-balancer-create, а так же создадим target_group.


<details><summary>balancer.tf</summary>

```
resource "yandex_lb_network_load_balancer" "balancer" {
  name = "balancer"
  deletion_protection = "false"
  listener {
    name = "test-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.lb-group.id
    healthcheck {
      name = "http"
      interval = 2
      timeout = 1
      unhealthy_threshold = 2
      healthy_threshold   = 2
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

```

</details>

и допишем в vmgroup.tf зависимость:

```

load_balancer {
        target_group_name = "balancer"
    }

```

<details><summary>target_group.tf</summary>

```

resource "yandex_lb_target_group" "lb-group" {
  name           = "target-group"

  target {
    subnet_id    = yandex_vpc_subnet.public.id
    address   = yandex_compute_instance_group.vmgroup.instances[0].network_interface[0].ip_address
  }

  target {
    subnet_id    = yandex_vpc_subnet.public.id
    address   = yandex_compute_instance_group.vmgroup.instances.instances[1].network_interface[0].ip_address
  }

  target {
    subnet_id    = yandex_vpc_subnet.public.id
    address   = yandex_compute_instance_group.vmgroup.instances[2].network_interface[0].ip_address 
  }
  depends_on = [
    yandex_compute_instance_group.vmgroup
]
} 

```
</details>

Запусим код и проверим. После исполения кода видим, что создалась целевая группа и LoadBalancer

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud2/foto/5_1.JPG)

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud2/foto/6.JPG)

Проверим доступность через внешний IP
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud2/foto/7.JPG)

Картинка доступна.

Теперь остановим одну VM, картинка по прежнему доступна и как требуется в задании, сработали настройки восстановления после сбоев.

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud2/foto/8.JPG)