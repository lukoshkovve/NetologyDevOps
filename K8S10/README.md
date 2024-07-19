# Домашнее задание к занятию «Helm»

**Задание 1:**

Cоздадим отдельные пространства имен для данной задачи k8s001 и k8s002:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S10/foto/2.JPG)

Установим локально helm (скрипт возьмем из с официального сайта)

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S10/foto/1.JPG)

Для тестового чата буду использовать nginx, назавем его netology-nginx и создам его:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S10/foto/3.JPG)

В стуктуре созданого чарта создадим необходимые values с требуемым тегом.

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S10/foto/4.JPG)

**Задание 2:**

Установим чарт для namespace k8s001

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S10/foto/5.JPG)

Проверим, что все установилось:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S10/foto/6.JPG)

То же самое для другого manespace k8s002

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S10/foto/7.JPG)

Финально проверим что развернуто несколько копий приложения в разных namespace:

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/K8S10/foto/8.JPG)


