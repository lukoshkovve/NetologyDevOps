# Дипломный практикум в Yandex.Cloud

**Создание облачной инфраструктуры**

1. Создадим сервисный аккаунт
```
resource "yandex_iam_service_account" "sa" {
  name = "nolardiplom"
}
```
В Yandex Cloud используются роли, которые действуют для всех типов ресурсов это admin, editor, viewer и auditor
в задании нам зпрещено использовать роль admin, поэтому мы будем использовать роль editor (примитивную) которую привяжем к сервисному аккаунту.

```
resource "yandex_resourcemanager_folder_iam_member" "sa_editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}
```
2. Подготовим backend для Terraform, будем использовать S3 bucket

Для работы с Storage Service нам потребуется стватический ключ доступа

```
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}
```
а так же создадим бакет через TF с использованием этих ключей

```
resource "yandex_storage_bucket" "diplom-lukoshkov" {
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = "diplom-lukoshkov"
  acl    = "public-read"
}
```
Применим конфигурацию

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/1.JPG)


Далее опишем remote backend в проекте Terraform

```
terraform {

  backend "s3" {
    endpoint = "https://storage.yandexcloud.net"
    bucket = "diplom-lukoshkov"
    region = "ru-central1"
    key    = "state/terraform.tfstate"
    access_key = "access_key"
    secret_key = "secret_key"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

```

Файл terraform.tfstate содержит в себе все изменения которые происходили,  а так же защищает от выполнения параллельных задач. 

после применения кода: 

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/3.JPG)

В нутри нашего бакета он так же появился:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/4.JPG)


3. Создаем VPC с подсетями в разных зонах доступности:


```
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


```


После выполнения кода создались сеть и две подсети с разными зонами доступности

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/6.JPG)

так же проверим в веб интерфейсе
 
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/5.JPG)

после первичной настойки, у нас файл состояния находится в бакете и имеет актуальное состояние так же проверка кода на валидацию проходит успешно:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/7.JPG)


**Создание Kubernetes кластера**