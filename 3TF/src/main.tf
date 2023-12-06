resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
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


resource "null_resource" "web_hosts_provision" {
depends_on = [yandex_compute_instance.web, yandex_compute_instance.f_each, yandex_compute_instance.storage]


  provisioner "local-exec" {
    command  = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/inventory.yml ${abspath(path.module)}/test.yml"
    on_failure = continue
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
  }
    triggers = {
      always_run         = "${timestamp()}"
      playbook_src_hash  = file("${abspath(path.module)}/test.yml")
      ssh_public_key     = local.ssh
    }
}