# Домашнее задание к занятию «Запуск приложений в K8S»

**Задание 1:**


> Создадим отдельное пространство имен для данной задачи (чтобы небыло пересечений с другими сервисами)

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S3/foto/1.JPG)

Создадим Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Проблема видимо заключалась в конфликте портов 80 и 433 на которых пытается запуститься мультитул. Для решения этой проблемы испольуются две переменные среды HTTP_PORT и HTTPS_PORT которыми мы можем преопределить порт. В данном примере мы используем переменную HTTP_PORT которой присваемваем порт 1180.


```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-multitool
spec:
  selector:
    matchLabels:
      app: nginx-mt
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx-mt
    spec:
      containers:
      - name: nginx
        image: nginx:1.26.1
        ports:
        - containerPort: 80
      - name: multitool
        image: wbitt/network-multitool
        ports:
        - containerPort: 8080
        env: 
          - name: HTTP_PORT
            value: "1180"
```
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S3/foto/2.JPG)

Теперь необходимо, чтобы было 2 реплики 

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S3/foto/3.JPG)

Создаем сервис 

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-mt-svc
  namespace: k8s3
spec:
  selector:
    app: nginx-mt
  ports:
    - protocol: TCP
      name: nginx
      port: 80
      targetPort: 80    
    - protocol: TCP
      name: multitool
      port: 8080
      targetPort: 1180
```
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S3/foto/4.JPG)

Для multitool
```
apiVersion: v1
kind: Pod
metadata:
   name: multitool
   namespace: k8s3
spec:
   containers:
     - name: multitool
       image: wbitt/network-multitool
       ports:
        - containerPort: 8080
```

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S3/foto/5.JPG)

Проверяем, есть ли доступ из multitool до приложения

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S3/foto/6.JPG)


**Задание 2:**

Deployment приложения nginx:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-init-deploy
  namespace: k8s3
spec:
  selector:
    matchLabels:
      app: nginx-init
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx-init
    spec:
      containers:
      - name: nginx
        image: nginx:1.26.1
        ports:
        - containerPort: 80
      initContainers:
      - name: delay
        image: busybox
        command: ['sh', '-c', "until nslookup nginx-init-svc.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for nginx-init-svc; sleep 2; done"]


```
добавим и посмотрим статус

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S3/foto/7.JPG)


сервис 
```
apiVersion: v1
kind: Service
metadata:
  name: nginx-init-svc
  namespace: k8s3
spec:
  ports:
    - name: nginx-init
      port: 80
  selector:
    app: nginx-init
```
запускаем сервис и видим, что под nginx стартанул

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S3/foto/8.JPG)



