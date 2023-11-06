#cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.132.0.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image"
}

variable "vm_resurces" {
  type        = map(map(number))
  description = "resurces VM"
  default     = {
    vm_web_resources = {
      cores         = 2
      memory        = 2
      core_fraction = 5
      }
    vm_db_resources = {
      cores         = 2
      memory        = 2
      core_fraction = 20
      }
   }
}

variable "vm_metadata" {
  type        = map(string)
  description = "metadata MV"
  default     = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHMxw4gbW/nX9Q/1xGxgFjgvKb5lf3UH+PiuX8c3LwAVduVGr896dkuAiSHibP0G10LIrE8fgQXhEpgxC6nh1nyk85P8gJHuXh9FrUHRl8FuieSceWbpHIjaqGxJYX7y7KcCVCNW0PSm9Yqe3Q987mjzO5dP6eLUoOpq7OmX4ydTnMAKOBMUJb/DuB/cs8A6ieO4qgauJvzlwp0sbn/OrTJ+IbpbcOxnG2vBZAPDUefG87ZGVX0qGzS/2GhJY8HVSHfftKePrYYASzluK0TykceldRwtzqJqMRKIfzZWx1RAsyyCZTXdWR/6+dX5CUQAOlRWDclTdxzUXIhqPwQm2cUm6KJsdVlCx8XfWs2GdcXWqc1dIHZs6gqeYtXPSPfXvCcCh7ykEuTiE7HTbRAuZB5QLdf865nsbmHVWGtZCuMLj8YB5l5XCzvO4l9MjwXm/g2QyciRe4/M9JRtpZ533J/cTPGdOhZQ7zqXOEeVtIE0mlVMW6hbP0sLlLNYhY/DU= home@HOME-PC"
   }
}

