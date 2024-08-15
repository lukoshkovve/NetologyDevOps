# Домашнее задание к занятию «Безопасность в облачных провайдерах»

**Задание 1:**

>По заданию, мы буем использовать файлы конфигурации из предыдущего задания
Обратимся к оф. доккументации яндекс 
https://yandex.cloud/ru/docs/storage/operations/buckets/encrypt#add и добавим шифрование к уже имеющемуся бакету

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

// Управление ключами и ключевыми парами шифрования
resource "yandex_resourcemanager_folder_iam_member" "sa-kms-admin" {
  folder_id = var.folder_id
  role      = "kms.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}


// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

resource "yandex_kms_symmetric_key" "key-a" {
  name              = "key-a"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // 1 год
}

// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "lukoshkov" {
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = "lukoshkov"
  acl    = "public-read"
    server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
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

мы добавили в данный файл вот этот блок:

```
resource "yandex_resourcemanager_folder_iam_member" "sa-kms-admin" {
  folder_id = var.folder_id
  role      = "kms.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_kms_symmetric_key" "key-a" {
  name              = "key-a"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // 1 год
}
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

```

После выполнения кода у нас создался bucket с именем lukoshkov и KMS key-a:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud3/foto/1.JPG)

Сам симметричный ключ:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud3/foto/2.JPG)

И наша картинка после добавления, так же зашифрована (не доступна для просмотра):

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud3/foto/3.JPG)


2. Т. к. в задании сказано создать не через terraform, обратимся к консоли управления для создания статического веб-сайта в Object Storage 
оф. документация https://yandex.cloud/ru/docs/tutorials/web/static/console

Создаем сертафикат и ждем пока он пройдет валидацию

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud3/foto/10.JPG)

после чего указываем его во вкладке HTTPS и проверяем на нашем сайте, что у сайта стало защищенное соединение и используется именно наш сертификат Let's Encrypt


![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Cloud3/foto/9.JPG)

Задание выполнено.




