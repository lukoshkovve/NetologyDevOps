# Домашнее задание к занятию «Базовые объекты K8S»


> Чеклист готовности к домашнему заданию:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S2/foto/1.JPG)

**Задание 1:**

1. Создал манифест
2. Использовал image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
```
apiVersion: v1
kind: Pod
metadata:
  name: hello-world
spec:
  containers:
  - name: echoserver
    image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
    ports:
    - containerPort: 8080
```
Запустил

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S2/foto/2.JPG)

3. Прокинул порты и смотрю ответ с помощью curl
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S2/foto/3.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S2/foto/4.JPG)


**Задача 2:**

Манифест для пода с именем netology-web и севиса с именем netology-svc и с помощью селектора меток (label selectors) групирирую их.

```
apiVersion: v1
kind: Pod
metadata:
  name: netology-web
  labels:
  app: netology-web
spec:
  containers:
  - name: echoserver
    image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
    ports:
    - containerPort: 8080

---

apiVersion: v1
kind: Service
metadata:
  name: netology-svc
spec:
  selector:
    app: netology-web
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

Запускаю и прокидываю порты 

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S2/foto/5.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S2/foto/6.JPG)

Как результат, мы можем посмотреть ответ curl

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S2/foto/6.JPG)