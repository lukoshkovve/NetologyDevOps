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

data "template_file" "cloudinit" {
  template = "${file("/home/nolar/diplom-s3/main/cloud-init.yml")}"

  vars = {
   ssh_public_key = local.ssh-keys
   ssh_private_key = local.ssh-private-keys
  }
}
