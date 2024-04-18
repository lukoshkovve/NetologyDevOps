# Домашнее задание к занятию «Kubernetes. Причины появления. Команда kubectl»

**Задание 1:**

> MicroK8S установлен на удаленную машину


![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S1/foto/1.JPG)

> dashboard установлен

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S1/foto/2.JPG)

> в конфиг /var/snap/microk8s/current/certs/csr.conf.template добавил в [ alt_names ] IP.3 = 178.154.225.28 и обновил сертификат sudo microk8s refresh-certs --cert front-proxy-client.crt


**Задача 2:**

> Установил на локальную машину kubectl и настроил конфиг в .kube/config

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S1/foto/3.JPG)

> Пробросил порт microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 18443:443

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S1/foto/4.JPG)