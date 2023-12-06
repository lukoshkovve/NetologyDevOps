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
      image_id = "fd8idfolcq1l43h1mlft"
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
    ssh-keys           = local.ssh
  }

}