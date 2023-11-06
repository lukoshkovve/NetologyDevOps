resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "default-ru-central1-a" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_resourcemanager_cloud" "cloud-lukbiz" {
  name = "cloud-lukbiz"
}

resource "yandex_resourcemanager_cloud_iam_member" "admin" {
  cloud_id = "${data.yandex_resourcemanager_cloud.cloud-lukbiz.id}"
  role     = "admin"
  member   = "serviceAccount:ajem0hu99oibaap4lg1r"
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
  name        = local.web_instance
  platform_id = "standard-v1"
  metadata    = var.vm_metadata
    resources {
    cores         = var.vm_resurces.vm_web_resources.cores
    memory        = var.vm_resurces.vm_web_resources.memory
    core_fraction = var.vm_resurces.vm_web_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.default-ru-central1-a.id
    nat       = true
  }
}

resource "yandex_compute_instance" "platform1" {
  name        = local.db_instance
  metadata    = var.vm_metadata
  platform_id = "standard-v1"
  resources {
    cores         = var.vm_resurces.vm_db_resources.cores
    memory        = var.vm_resurces.vm_db_resources.memory
    core_fraction = var.vm_resurces.vm_db_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.default-ru-central1-a.id
    nat       = true
  }    
}

