resource "local_file" "inventory_cfg" {
  content = templatefile("${path.module}/ansible.tftpl",
	{
  	webservers	= yandex_compute_instance.web,
  	databases   = yandex_compute_instance.f_each,
  	storage = [yandex_compute_instance.storage]
	}
  )

  filename = "${abspath(path.module)}/inventory.yml"
}