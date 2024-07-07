# Домашнее задание к занятию «Конфигурация приложений»

**Задание 1:**

По традиции, создадим отдельное пространство имен для данной задачи (чтобы небыло пересечений с другими сервисами)

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S8/foto/1.JPG)

>Создал Deployment приложения состоящего из контейнеров nginx и multitool.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-multitool
  namespace: k8s8
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
        volumeMounts:
            - name: index
              mountPath: /usr/share/nginx/html/
      - name: multitool
        image: wbitt/network-multitool
        ports:
        - containerPort: 8080
        env:
          - name: HTTP_PORT
            valueFrom:
              configMapKeyRef:
                name: configmap-multitool
                key: HTTP_PORT
      volumes:
      - name: index
        configMap:
          name: configmap-multitool
```

>Configmap

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: configmap-multitool
  namespace: k8s8
data:
  HTTP_PORT: '1180'
  index.html: |
    <html>
    <h1>test config</h1>
    </html>
```
>Service

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-mt-svc
  namespace: k8s8
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
Под стартовал и оба контейнера работают:
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S8/foto/2.JPG)

Теперь проверим, что вывод curl сервиса соответствует файлу конфигурации nginx который мы указали в configmap

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S8/foto/3.JPG)


**Задание 2:**

>можем взять ту же связку, что из первого задания но исключить multitool и немного видоизменить под текущую задачу

сделал необходимую связку
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-2
  namespace: k8s8
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
        image: nginx:1.26.1
        ports:
        - containerPort: 80
        volumeMounts:
        - name: index
          mountPath: /usr/share/nginx/html/
      volumes:
      - name: index
        configMap:
          name: configmap-nginx

---

apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: k8s8
spec:
  type: ClusterIP
  selector:
    app: nginx
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: 80

---

apiVersion: v1
kind: ConfigMap
metadata:
  name: configmap-nginx
  namespace: k8s8
data:
  index.html: |
    <html>
    <h1>test config</h1>
    </html>
```

создал сертификат и добавил его

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S8/foto/4.JPG)

Написал ingress

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress
  namespace: k8s8
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    kubernetes.io/ingress.class: nginx
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - myingressssl.com
    secretName: ingress-cert
  rules:
  - host: myingressssl.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-service
            port:
              number: 80
```

проверяем работу https

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S8/foto/5.JPG)