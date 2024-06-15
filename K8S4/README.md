# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

**Задание 1:**

Создадим отдельное пространство имен для данной задачи (чтобы небыло пересечений с другими сервисами)

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S4/foto/1.JPG)

>Создал Deployment приложения из друх контейнеров  (nginx и multitool), с количеством реплик равное трем.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-multitool
spec:
  selector:
    matchLabels:
      app: nginx-mt
  replicas: 3
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
Запустил, условия по количеству реплик - выполнено.
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S4/foto/2.JPG)

Написал Service

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-mt-svc
  namespace: k8s4
spec:
  selector:
    app: nginx-mt
  ports:
    - protocol: TCP
      name: nginx
      port: 9001
      targetPort: 80    
    - protocol: TCP
      name: multitool
      port: 9002
      targetPort: 1180
```
Запустил, сервис слушает порты 9001 и 9002
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S4/foto/3.JPG)

Для multitool
```
apiVersion: v1
kind: Pod
metadata:
   name: multitool
   namespace: k8s4
spec:
   containers:
     - name: multitool
       image: wbitt/network-multitool
       ports:
        - containerPort: 8080
```
Запускаем и смотрим IP адресса для дальнейшей проверки доступности.

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S4/foto/4.JPG)

Переходим в pod multitool и проверяем доступность по IP

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S4/foto/5.JPG)

Далее проверяем доступность подов по доменному имени сервиса.
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S4/foto/6.JPG)

**Задание 2:**

Создаем отдельный сервис у которого будет возможность доступа к nginx с типом NodePort

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-mt-svc-nodeport
  namespace: k8s4
spec:
  type: NodePort
  selector:
    app: nginx-mt
  ports:
    - port: 80
      name: nginx-port
      targetPort: 80
      nodePort: 30080
    - port: 8080
      name: multitool-port
      targetPort: 1180
      nodePort: 31180
```
Запускаем, смотрим, что все порты сопоставлены
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S4/foto/7.JPG)

Проверяем доступность подов по внешним портам

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S4/foto/8.JPG)