# Домашнее задание к занятию "Работа с roles"

**1-2**.	
> Созданы requirements.yml для ClickHouse, Vector и LightHouse на основе предложенной роли из первого задания

ClickHouse:
```
---

 - name: сlickhouse
   src: git@github.com:lukoshkovve/NetologyDevOps.git
   scm: git
   version: roles_ansible_clickhouse

```
Vector:
```
---
 - name: vector
   src: git@github.com:lukoshkovve/NetologyDevOps.git
   scm: git
   version: roles_ansible_vector
```

LightHouse:
```

 ---
 - name: lighthouse
   src: git@github.com:lukoshkovve/NetologyDevOps.git
   scm: git
   version: role_ansible_lighthouse

```
**3**.
> Созданы каталоги в папку role
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Config4/foto/4.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Config4/foto/5.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Config4/foto/6.JPG)

**4**.
> заполнены все task, и разнесены переменные
все заполненные файлы представлены в репо.


**5**.
> Необходимые шаблоны перененсены

**6**.
> в файле README.md репозитория для каждой роли определены переменные, которые можем менять пользователь.

**7-8-9**. 
>Выполнение playbook для каждого сервиса отдельно.
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Config4/foto/1.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Config4/foto/2.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Config4/foto/3.JPG)

**10**.
> Ссылки на ветки с ROLES (папки с playbook в корне задания)

clickhouse

https://github.com/lukoshkovve/NetologyDevOps/tree/role_ansible_clickhouse

vector

https://github.com/lukoshkovve/NetologyDevOps/tree/roles_ansible_vector

lighthouse

https://github.com/lukoshkovve/NetologyDevOps/tree/role_ansible_lighthouse
