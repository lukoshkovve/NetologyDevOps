# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

**Задание 1:**

По традиции, создадим отдельное пространство имен для данной задачи (чтобы небыло пересечений с другими сервисами)

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S5/foto/1.JPG)

>Создал Deployment приложения frontend из образа nginx, с количеством реплик равное трем.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: k8s5
  labels:
    app: frontnetology
spec:
  selector:
    matchLabels:
      app: frontnetology
  replicas: 3
  template:
    metadata:
      labels:
        app: frontnetology
        component: network
    spec:
      containers:
      - name: nginx
        image: nginx:1.26.1
        ports:
        - containerPort: 80
```
Запустил, условия по количеству реплик - выполнено.
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S5/foto/2.JPG)

>Создал Deployment приложения backend из образа multitool:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: k8s5
  labels:
    app: backendnetology
spec:
  selector:
    matchLabels:
      app: backendnetology
  replicas: 1
  template:
    metadata:
      labels:
        app: backendnetology
        component: network
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool
        ports:
        - containerPort: 8080
        env: 
          - name: HTTP_PORT
            value: "1180"
```
Запустил, все на месте:
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S5/foto/3.JPG)

>Создаем сервис:
```
apiVersion: v1
kind: Service
metadata:
  name: service
  namespace: k8s5
  labels:
    component: network
spec:
  selector:
    component: network
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
Запускаем и смотрим 

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S5/foto/4.JPG)

Curl проверяем доступность с backend

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S5/foto/5.JPG)

С frontend
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S5/foto/6.JPG)

**Задание 2:**

>проверим, что в нашем minikube включен плагин ingress

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S5/foto/7.JPG)

Создадим ingress в котором при запросе только по адресу открывался frontend а при добавлении /api - backend.
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minimal-ingress
  namespace: k8s5
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: ingressnetology.info
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: service
            port:
              number: 9001
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: service
            port:
              number: 9002
```
Применим и посмотрим результат:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S5/foto/8.JPG)

Прописал в etc/hosts сопоставление DNS ip ingress, чтобы можно было по имени хоста обращаться.

Проверяем доступность:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S5/foto/9.JPG)