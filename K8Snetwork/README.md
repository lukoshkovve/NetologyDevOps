# Домашнее задание к занятию «Как работает сеть в K8S»

**Задание 1:**

Cоздадим отдельное пространство имен для данной задачи app:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8Snetwork/foto/1.JPG)

>Пишем манифесты frontend

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool
        ports:
        - containerPort: 8080
        env:
          - name: HTTP_PORT
            value: "1180"

---
apiVersion: v1
kind: Service
metadata:
  name: frontend-svc
  namespace: app
spec:
  selector:
    app: frontend
  ports:
    - protocol: TCP
      name: multitool
      port: 9002
      targetPort: 1180
```
>Пишем манифесты backend

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool
        ports:
        - containerPort: 8080
        env:
          - name: HTTP_PORT
            value: "1180"

---
apiVersion: v1
kind: Service
metadata:
  name: backend-svc
  namespace: app
spec:
  selector:
    app: backend
  ports:
    - protocol: TCP
      name: multitool
      port: 9002
      targetPort: 1180

```
>Пишем манифесты cache

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cache
  namespace: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cache
  template:
    metadata:
      labels:
        app: cache
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool
        ports:
        - containerPort: 8080
        env:
          - name: HTTP_PORT
            value: "1180"

---
apiVersion: v1
kind: Service
metadata:
  name: cache-svc
  namespace: app
spec:
  selector:
    app: cache
  ports:
    - protocol: TCP
      name: multitool
      port: 9002
      targetPort: 1180
```


Применим и посмотрим, что получилось и все ли поды видят друг друга на примере frontend:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8Snetwork/foto/2.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8Snetwork/foto/3.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8Snetwork/foto/4.JPG)

Далее напишем запрещающее правило для всего, потом будем разрешать, что нам необходимо:
(из официальной документации и немного его модифицируем)

``---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: app
spec:
  podSelector: {}
  policyTypes:
  - Ingress

```
Применим и роверим, видят ли друг друга поды

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8Snetwork/foto/5.JPG)

Политики применились трафик запрещен. Теперь по заданию необходимо, чтобы чтобы была связка видимости frontend -> backend -> cache

>Пишем политику для frontend -> backend

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: front-back
  namespace: app
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - protocol: TCP
          port: 1180
```
>Применяем политику, frontend видит backend но не видит cache

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8Snetwork/foto/6.JPG)

>Пишем политику для backend -> cache

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: back-cache
  namespace: app
spec:
  podSelector:
    matchLabels:
      app: cache
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: backend
      ports:
        - protocol: TCP
          port: 1180
```
В итоге задача решена backend видит cache но не видит frontend:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8Snetwork/foto/6.JPG)

Наши политики выглядят следующим образом:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8Snetwork/foto/7.JPG)