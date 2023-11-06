# Домашнее задание к занятию "Основы Terraform. Yandex Cloud"
**1**.

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/2TF/foto/2.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/2TF/foto/1.JPG)

> Не хватало ресурса - resource "yandex_resourcemanager_cloud_iam_member"

> В блоке "yandex_compute_instance" 
platform_id = "standard-v1"
cores         = 2

> preemptible = true - означает, что ВМ прерываемая и можно ее остановить принудительно в любой момент, так же такая ВМ может остановиться автоматом, если ресурсов для других ВМ не прирываемых не будет хватать.

> core_fraction=5 - это процент гаранитрованной доли vCPU (в данном случае 5%). В следствии чего цена потребляемых ресурсов будет меньше, чем если бы использовалось на 100%, но в то же время, производительность может быть выше, если никто другой не потребляет данный ресурс.




**2**.	
переменные создал, в main, так же на них сослался
```
variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image"
}

variable "vm_web_neme" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "yandex_compute_instance"
}
```
После добавления переменных `terraform plan` - без именений.

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/2TF/foto/3.JPG)



**3**.	

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/2TF/foto/4.JPG)


**4**.	

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/2TF/foto/5.JPG)

**5**.	

Использовал интерполяцию

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/2TF/foto/10.JPG)

В файле main.tf использовал данные переменные

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/2TF/foto/11.JPG)

**6**.	

Создал одну переменную 

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/2TF/foto/12.JPG)

так же для metadata

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/2TF/foto/13.JPG)

Далее использовал их в main

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/2TF/foto/14.JPG)

удалил все ненужные переменные.

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/2TF/foto/9.JPG)

