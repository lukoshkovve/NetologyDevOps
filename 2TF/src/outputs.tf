output "netology-develop-platform-web" {
  description = "ip public web"
  value       = yandex_compute_instance.platform.network_interface.0.nat_ip_address
}

output "netology-develop-platform-db" {
  description = "ip public db"
  value       = yandex_compute_instance.platform1.network_interface.0.nat_ip_address
}