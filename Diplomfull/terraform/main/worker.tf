data "yandex_compute_image" "worker" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "worker" {
  depends_on = [yandex_compute_instance.master]
  count = var.counts_node
  name = "worker-${count.index + 1}"
  platform_id       = "standard-v1"
  zone = var.zone2

  resources {
    cores           = 2
    memory          = 2
    core_fraction   = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.worker.id
      size = 15
      type = "network-hdd"
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet2.id
    nat        = true
  }
   
  scheduling_policy {
    preemptible = true
  }
  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}