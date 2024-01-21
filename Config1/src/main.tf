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


module "vpc_develop" {
  source       = "./vpc"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
  env_name = "develop"
}

module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = "develop"
  network_id      = module.vpc_develop.network_id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [ module.vpc_develop.subnet_id ]
  instance_name   = "web"
  instance_count  = 1
  image_family    = "ubuntu-2004-lts"
  public_ip       = true
  
  metadata = {
      user-data          = data.template_file.userdata.rendered #Для демонстрации №3
      serial-port-enable = 1
  }

}

#Пример передачи cloud-config в ВМ для демонстрации №3

data template_file "userdata" {
  template = file("${path.module}/cloud-init.yml")

  vars = {
	ssh_public_key = file("~/.ssh/id_ed25519.pub")
  }
}
