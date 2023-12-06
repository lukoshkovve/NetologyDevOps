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
      image_id = "fd8idfolcq1l43h1mlft"
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
    serial-port-enable = 1
    ssh-keys           = local.ssh
  }

}