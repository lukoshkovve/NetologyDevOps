resource "local_file" "inventory_cfg" {
  content = templatefile("/home/nolar/diplom-s3/main/templates/inventory.tftpl", 
     {
      master = [yandex_compute_instance.master],
      worker1 = [yandex_compute_instance.worker[0]],
      worker2 = [yandex_compute_instance.worker[1]]
     }
)

  filename = "/home/nolar/diplom-kube/kubespray/inventory/mycluster/inventory.yaml"
}
