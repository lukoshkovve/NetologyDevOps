# Дипломный практикум в Yandex.Cloud

**Создание облачной инфраструктуры**

1. Создадим сервисный аккаунт
```
resource "yandex_iam_service_account" "sa" {
  name = "nolardiplom"
}
```
В Yandex Cloud используются роли, которые действуют для всех типов ресурсов это admin, editor, viewer и auditor
в задании нам зпрещено использовать роль admin, поэтому мы будем использовать роль editor (примитивную) которую привяжем к сервисному аккаунту.

```
resource "yandex_resourcemanager_folder_iam_member" "sa_editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}
```
2. Подготовим backend для Terraform, будем использовать S3 bucket

Для работы с Storage Service нам потребуется стватический ключ доступа

```
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}
```
а так же создадим бакет через TF с использованием этих ключей

```
resource "yandex_storage_bucket" "diplom-lukoshkov" {
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = "diplom-lukoshkov"
  acl    = "public-read"
}
```
Применим конфигурацию

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/1.JPG)


Далее опишем remote backend в проекте Terraform

```
terraform {

  backend "s3" {
    endpoint = "https://storage.yandexcloud.net"
    bucket = "diplom-lukoshkov"
    region = "ru-central1"
    key    = "state/terraform.tfstate"
    access_key = "access_key"
    secret_key = "secret_key"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

```

Файл terraform.tfstate содержит в себе все изменения которые происходили,  а так же защищает от выполнения параллельных задач. 

после применения кода: 

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/3.JPG)

В нутри нашего бакета он так же появился:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/4.JPG)


3. Создаем VPC с подсетями в разных зонах доступности:


```
#Создаем простую VPC
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

#Создаем подсеть subnet1
resource "yandex_vpc_subnet" "subnet1" {
  name           = var.subnet1
  zone           = var.zone1
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.subnet1_cidr
}

#Создаем подсеть subnet2
resource "yandex_vpc_subnet" "subnet2" {
  name           = var.subnet2
  zone           = var.zone2
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.subnet2_cidr
}


```


После выполнения кода создались сеть и две подсети с разными зонами доступности

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/6.JPG)

так же проверим в веб интерфейсе
 
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/5.JPG)

после первичной настойки, у нас файл состояния находится в бакете и имеет актуальное состояние так же проверка кода на валидацию проходит успешно:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/7.JPG)


**Создание Kubernetes кластера**

а) Для Kubernetes кластера нам необходимо создать master ноду и две worker ноды и настроить сеть с публичными ip для дальнейшего управления. Из условий задания необходимо сделать прерываемую ВМ, для этого необходимо установить в политике планирования `scheduling_policy` параметр `preemptible` равным rtue. Для экономии ресурсов, worker nodes сделаем по ресурсам минимально возможные.

Для master node:

```
resource "yandex_compute_instance" "master" {
  name = "master"
  platform_id       = "standard-v1"
  zone = var.zone1

  resources {
    cores           = 2
    memory          = 2
    core_fraction   = 20
  }
  boot_disk {
    initialize_params {
      image_id = "fd8idfolcq1l43h1mlft"
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet1.id
    nat        = true
  }
   
  scheduling_policy {
    preemptible = true
  }
  metadata = {
    ssh-keys = "ubuntu:${local.ssh-keys}"
    serial-port-enable = "1"
  }
}
```

Для worker nodes:

```
resource "yandex_compute_instance" "worker" {
  count = 2
  name = "worker-${count.index + 1}"
  platform_id       = "standard-v1"
  zone = var.zone2

  resources {
    cores           = 2
    memory          = 1
    core_fraction   = 5
  }
  boot_disk {
    initialize_params {
      image_id = "fd8idfolcq1l43h1mlft"
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
    ssh-keys = "ubuntu:${local.ssh-keys}"
    serial-port-enable = "1"
  }
}
```
Помимо уменьшения ресурсов и процента использования CPU добавен блок который описывает количество worker nodes и формирование имени:

```
count = 2
  name = "worker-${count.index + 1}"
```

применяем код:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/8.JPG)

смотрим в веб интерфейс:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/9.JPG)

Все необходимые ВМ созданы с требуемыми ресурсами и в нужном количестве.

без дополнительных ручных действий можно выполнить terraform destroy и terraform apply

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/12.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/13.JPG)

б) Для подготовки конфигурации ansible воспользуемся Kubespray, для этого склонируем требуемую ветку себе

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/10.JPG)
 
 и установим все необходимые зависимости

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/11.JPG)

Далее нам необходимо создать inventory который представляет из себя список хостов и ролей. Т.к. мы хотим, чтобы у нас код был максимально автоматизированным мы можем файл inventory.yaml заполнить автоматически применив шаблон.

<details><summary>inventory.tftpl</summary>

```
[all]
%{ for i in master }
${i["name"]} ansible_host=${i["network_interface"][0]["ip_address"]} ip=${i["network_interface"][0]["ip_address"]} access_ip=${i["network_interface"][0]["ip_address"]}
%{ endfor }
%{ for i in worker1 }
${i["name"]} ansible_host=${i["network_interface"][0]["ip_address"]} ip=${i["network_interface"][0]["ip_address"]} access_ip=${i["network_interface"][0]["ip_address"]}
%{ endfor }
%{ for i in worker2 }
${i["name"]} ansible_host=${i["network_interface"][0]["ip_address"]} ip=${i["network_interface"][0]["ip_address"]} access_ip=${i["network_interface"][0]["ip_address"]}
%{ endfor }

[kube_control_plane]
%{ for i in master }
${i["name"]}
%{ endfor }

[etcd]
%{ for i in master }
${i["name"]}
%{ endfor }

[kube_node]
%{ for i in worker1 }
${i["name"]}
%{ endfor }
%{ for i in worker2 }
${i["name"]}
%{ endfor }

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr

```

</details>

А так же список самих инстансов откуда достаем атрибуты:


<details><summary>ansible.tf</summary>

```
resource "local_file" "inventory_cfg" {
  content = templatefile("/home/nolar/diplom-s3/main/templates/inventory.tftpl", 
     {
      master = [yandex_compute_instance.master],
      worker1 = [yandex_compute_instance.worker[0]],
      worker2 = [yandex_compute_instance.worker[1]]
     }
)

  filename = "/home/nolar/diplom-kube/kubespray/inventory/cluster/inventory.yml"
}
```
</details>

Запускаем 

```
ansible-playbook -u ubuntu --private-key ~/.ssh/id_rsa -i inventory/mycluster/inventory.yaml cluster.yml -b

```
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/14.JPG)

Настраиваем конфиг на мастере и получаем готовый к дальнейшей работе кластер kubernetes

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/15.JPG)

**Создание тестового приложения**

Для нашего проекта будем использовать GitLab и для этго воспользуемся Managed Service for GitLab (это решение быстрое и удобное в использовании)

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/16.JPG)

установим и зарегестрируем RUNNER на master

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/17.JPG)

runner зарегистрирован и ожидает задания.

Напишем 
<details><summary>gitlab-ci.yaml</summary>

```
stages:
  - build
  - deploy

variables:
  IMAGE_NAME: nginx-diplom

build:
  stage: build
  image:
    name: gcr.io/kaniko-project/executor:v1.12.1-debug
    entrypoint: [""]
  script:
    - echo "{\"auths\":{\"$CI_REGISTRY\":{\"username\":\"$CI_REGISTRY_USER\",\"password\":\"$CI_REGISTRY_PASSWORD\"}}}" > /kaniko/.docker/config.json
    - /kaniko/executor 
      --context $CI_PROJECT_DIR
      --dockerfile $CI_PROJECT_DIR/Dockerfile 
      --destination $CI_REGISTRY/nolar/netology/$IMAGE_NAME:$CI_COMMIT_SHORT_SHA
```

</details>

 (DID не стал использовать, потому как в реальных проектах это мало где используется. Связанно это с безопасностью т.к. при таком методе необходимо включать privileged = true. Подход с kaniko решает данную проблему и на мой взгляд работает стабильнее)



<details><summary>Dockerfile</summary>

FROM nginx:alpine
# Заменяем дефолтную страницу nginx соответствующей веб-приложению
RUN rm -rf /usr/share/nginx/html/*
RUN rm -rf /etc/nginx/conf.d/nginx.conf
COPY ./frontend/index.html /usr/share/nginx/html

COPY ./frontend/nginx.conf /etc/nginx/conf.d/nginx.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]


</details>

в index.html у нас содержится статичная страница с текстом "Делаю проект нетологии"

```
<!DOCTYPE html>
<html>

<head>
</head>

<body>
    <h1>netology diplom</h1>
</body>

</html>

```

Запускаем <details><summary>build</summary>

```
Running with gitlab-runner 17.4.0 (b92ee590)
  on runnernetology kpPFSDZH, system ID: r_4fgTky1pTpz0
Preparing the "docker" executor
00:03
Using Docker executor with image gcr.io/kaniko-project/executor:v1.12.1-debug ...
Pulling docker image gcr.io/kaniko-project/executor:v1.12.1-debug ...
Using docker image sha256:68aaceaa620b8a0bed42ce812f4994747b8ad69365806aa8883008f574e8054a for gcr.io/kaniko-project/executor:v1.12.1-debug with digest gcr.io/kaniko-project/executor@sha256:a7ea9f69d77d7e7a0ea821f15069be45420a536f81ab5787a988659e48c25377 ...
Preparing environment
00:01
Running on runner-kppfsdzh-project-1-concurrent-0 via b87eaeeec109...
Getting source from Git repository
00:01
Fetching changes with git depth set to 20...
Reinitialized existing Git repository in /builds/nolar/netology/.git/
Checking out 21d5c982 as detached HEAD (ref is main)...
Skipping Git submodules setup
Executing "step_script" stage of the job script
00:06
Using docker image sha256:68aaceaa620b8a0bed42ce812f4994747b8ad69365806aa8883008f574e8054a for gcr.io/kaniko-project/executor:v1.12.1-debug with digest gcr.io/kaniko-project/executor@sha256:a7ea9f69d77d7e7a0ea821f15069be45420a536f81ab5787a988659e48c25377 ...
$ echo "{\"auths\":{\"$CI_REGISTRY\":{\"username\":\"$CI_REGISTRY_USER\",\"password\":\"$CI_REGISTRY_PASSWORD\"}}}" > /kaniko/.docker/config.json
$ /kaniko/executor --context $CI_PROJECT_DIR --dockerfile $CI_PROJECT_DIR/Dockerfile --destination $CI_REGISTRY/nolar/netology/$IMAGE_NAME:nginx-$CI_COMMIT_SHORT_SHA
INFO[0000] Retrieving image manifest nginx:alpine       
INFO[0000] Retrieving image nginx:alpine from registry index.docker.io 
INFO[0001] Built cross stage deps: map[]                
INFO[0001] Retrieving image manifest nginx:alpine       
INFO[0001] Returning cached image manifest              
INFO[0001] Executing 0 build triggers                   
INFO[0001] Building stage 'nginx:alpine' [idx: '0', base-idx: '-1'] 
INFO[0001] Unpacking rootfs as cmd COPY . . requires it. 
INFO[0004] WORKDIR /app                                 
INFO[0004] Cmd: workdir                                 
INFO[0004] Changed working directory to /app            
INFO[0004] Creating directory /app with uid -1 and gid -1 
INFO[0004] Taking snapshot of files...                  
INFO[0004] COPY . .                                     
INFO[0004] Taking snapshot of files...                  
INFO[0004] COPY ./frontend/nginx.conf /etc/nginx/nginx.conf 
INFO[0004] Taking snapshot of files...                  
INFO[0004] COPY ./frontend/index.html /usr.share/nginx/html 
INFO[0004] Taking snapshot of files...                  
INFO[0004] EXPOSE 80                                    
INFO[0004] Cmd: EXPOSE                                  
INFO[0004] Adding exposed port: 80/tcp                  
INFO[0004] Pushing image to nolar.gitlab.yandexcloud.net:5050/nolar/netology/nginx-diplom:nginx-21d5c982 
INFO[0005] Pushed nolar.gitlab.yandexcloud.net:5050/nolar/netology/nginx-diplom@sha256:9c9b0d2e4a42bf199cb995e8af4034c1675b5159095a939678d4e1d39a04eb65 
Cleaning up project directory and file based variables
00:01
Job succeeded

```

</details>

И смотрим, что у нас в локальном registry появился образ nginx с нашим тестовым приложением

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/18.JPG)


**Подготовка системы мониторинга и деплой приложения**


1. Мы будем использовать Helm для установки стека 
проверим версию Helm
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/19.JPG)
данная версия была установлена на этапе формирования инфраструктуры из файла cloud-init

добавим репозиторий и найдем нужный чарт

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/20.JPG)

Установим стек

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/21.JPG)

Далее нам необходимо сделать, чтобы службы Prometheus и Grafana были доступны извне для этого в манифесте установим тип NodePort.

пример кода:

```
  ports:
  - name: http-web
    nodePort: 30003
    port: 80
    protocol: TCP
    targetPort: 3000
  selector:
    app.kubernetes.io/instance: stable
    app.kubernetes.io/name: grafana
  sessionAffinity: None
  type: NodePort
```


![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/22.JPG)
после наших правок видим:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/25.JPG)

стали доступны web интерфейсы Prometheus и Grafana

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/23.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/24.JPG)

2. Пишем Deployment приложения
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: netology-site
  namespace: netology
  labels:
    app: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nolar.gitlab.yandexcloud.net:5050/nolar/netology/nginx-diplom:21d5c982
        ports:
        - containerPort: 80
```
прокидываем порт наружу
```
apiVersion: v1
kind: Service
metadata:
    name: netology-site
    namespace: netology
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    nodePort: 30004
```
После применения конфигурации 
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/27.JPG)

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/26.JPG)

Наш простой сайт доступен извне и отображается, то что мы туда положили

**Установка и настройка CI/CD**

1. Данное требование у нас уже исполняется (когда образ nginx добавлял все необходимые настройки сделал)
2. Реализуем по следующим образом: при выполнении задания мы возьмем последний тег и подставим его в наш deployment и через SSH реализуем передачу и далее исполнение этого deployment.

добавим все необходимые переменные в GitLab
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/28.JPG)

и отредактируем наш 

<details><summary>.gitlab-ci.yml</summary>



stages:
  - build
  - deploy

variables:
  IMAGE_NAME: nginx-diplom

build:
  stage: build
  image:
    name: gcr.io/kaniko-project/executor:v1.12.1-debug
    entrypoint: [""]
  script:
    - echo "{\"auths\":{\"$CI_REGISTRY\":{\"username\":\"$CI_REGISTRY_USER\",\"password\":\"$CI_REGISTRY_PASSWORD\"}}}" > /kaniko/.docker/config.json
    - /kaniko/executor 
      --context $CI_PROJECT_DIR
      --dockerfile $CI_PROJECT_DIR/Dockerfile 
      --destination $CI_REGISTRY/nolar/netology/$IMAGE_NAME:$CI_COMMIT_SHORT_SHA

deploy:
  stage: deploy
  image: ubuntu
  variables:
    TAG: $CI_COMMIT_SHORT_SHA
  script:
  - | # устанавливаем ssh клиент
     apt-get update
     apt-get install openssh-client -y
     apt-get install curl -y
     curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
     chmod +x /usr/local/bin/docker-compose 


  - | # если ключи заданы файлами - переносим ключи в переменные
      test -f "$SSH_KEY_PRIVATE" && export SSH_KEY_PRIVATE=`cat $SSH_KEY_PRIVATE`
      test -f "$SSH_KEY_PUB" && export SSH_KEY_PUB=`cat $SSH_KEY_PUB`

  - | # подготавливаем SSH ключи
      mkdir ~/.ssh
      echo "$SSH_KEY_PRIVATE" > ~/.ssh/id_rsa
      echo "$SSH_KEY_PUB" > ~/.ssh/id_rsa.pub
      chmod 400 ~/.ssh/id_rsa
  
  - | 
      ssh -o StrictHostKeyChecking=no "$SSH_USER@$SSH_HOST"  "cat  > /home/ubuntu/deployment.yaml<< EOF
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: netology-site
        namespace: netology
        labels:
          app: nginx
      spec:
        selector:
          matchLabels:
            app: nginx
        replicas: 1
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nolar.gitlab.yandexcloud.net:5050/nolar/netology/nginx-diplom:"$TAG"
              ports:
              - containerPort: 80
      EOF"
      #scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r deployment.yaml "$SSH_USER@$SSH_HOST":/home/ubuntu/deployment.yaml
      ssh -o StrictHostKeyChecking=no "$SSH_USER@$SSH_HOST" "kubectl apply -f deployment.yaml -n netology"

</details>

Проверка работы кода:

смотрим на веб интерфейс (там есть версия нашего сайта)

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/29.JPG)

теперь только меняем версию в файле index.html на версию 1.1 и нажимаем commit

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/30.JPG)

задание создано автоматически по коммиту

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/31.JPG)

Stage deploy выполнен удачно так же мы видим в логах, что наш сайт имеет статус configured

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/32.JPG)


смотрим на веб 

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Yandex/foto/33.JPG)

версия поменялась, значит все прошло как и было необходимо из условий.

