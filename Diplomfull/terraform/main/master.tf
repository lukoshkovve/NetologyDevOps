data "yandex_compute_image" "master" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "master" {
  name = "master"
  platform_id       = "standard-v1"
  zone = var.zone1

  resources {
    cores           = 4
    memory          = 8
    core_fraction   = 20
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.master.id
      size = 15
      type = "network-hdd"
    }
  }
  
  metadata = {
    ssh-keys           = "ubuntu:${local.ssh-keys}"
    serial-port-enable = "1"
    user-data          = data.template_file.cloudinit.rendered
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet1.id
    nat        = true
  }
   
  scheduling_policy {
    preemptible = true
  }

}