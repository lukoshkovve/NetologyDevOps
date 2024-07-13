# Домашнее задание к занятию «Обновление приложений»

**Задание 1:**

По традиции, создадим отдельное пространство имен для данной задачи (чтобы небыло пересечений с другими сервисами)

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S11/foto/1.JPG)

Поскольу у нас есть жесткие ограничения по ресурсам то как вариант можно рассмотреть стратегию по умолчанию Rolling Update и задать жестко следующие ограничения:

```
maxSurge: 20%
maxUnavailable: 20%
```
так же необходимо провести анализ и запускать обновления во время, когда нагрузка на сервисы будет минамальной. Данная стратегия постепенно заменит все сервисы без ущерба производительности. В случае если надо будет откатиться, это так же можно будет сделать безболезненно.

Про моженрые версии, если предпологается, что они не умеют работать со старыми версиями (нет обратной совместимости), то необходимо чтобы при добавлении новых они проходили проверку и если все нормально работает, старые версии можно будет удалить (здесь параметр  maxUnavailable: 100%)



**Задание 2:**

>Пишем deployment


```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-multitool
  namespace: k8s11
  annotations:
    kubernetes.io/change-cause: "nginx 1.19"
spec:
  selector:
    matchLabels:
      app: nginx-mt
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 3
      maxUnavailable: 3
  template:
    metadata:
      labels:
        app: nginx-mt
    spec:
      containers:
      - name: nginx
        image: nginx:1.19
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

Применил, на выходе 5 реплик с версией nginx 1.19. Так же установил параметры maxSurge и maxUnavailable в абсолютном заначении равное 3, исходя из того, что 3 могут быть недоступны при обновлении, тогда как 2 останутся работать на старых версиях.

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S11/foto/2.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S11/foto/3.JPG)

Теперь обновим nginx до 1.20. Внесем в наш deployment необходимые изменения и применим его

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-multitool
  namespace: k8s11
  annotations:
    kubernetes.io/change-cause: "nginx 1.20"
spec:
  selector:
    matchLabels:
      app: nginx-mt
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 3
      maxUnavailable: 3
  template:
    metadata:
      labels:
        app: nginx-mt
    spec:
      containers:
      - name: nginx
        image: nginx:1.20
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

Обновление прошло успешно, версия nginx поменялась

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S11/foto/4.JPG)

Теперь необходимо подняться до версии 1.28, подправит deployment

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-multitool
  namespace: k8s11
  annotations:
    kubernetes.io/change-cause: "nginx 1.28"
spec:
  selector:
    matchLabels:
      app: nginx-mt
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 3
      maxUnavailable: 3
  template:
    metadata:
      labels:
        app: nginx-mt
    spec:
      containers:
      - name: nginx
        image: nginx:1.28
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

Видим, что обновление версии не может пройти, однако два пода продолжают работать и приложение доступно.

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S11/foto/5.JPG)

История нам говорит, что у нас было 3 ревизии:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S11/foto/6.JPG)

Откатываемся на версию 1.20, смотрим что все поды запущены и так же проверяем историю:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S11/foto/7.JPG)
