# Домашнее задание к занятию 3. «Введение. Экосистема. Архитектура. Жизненный цикл Docker-контейнера»
**Задача 1**.

> Опубликуйте созданный fork в своём репозитории и предоставьте ответ в виде ссылки на

  https://hub.docker.com/repository/docker/lukoshkov82/dev/general *tag* site


**Задача 2**.

> Сценарий:

● высоконагруженное монолитное Java веб-приложение - больше всего подойдет виртуальная машина

● Nodejs веб-приложение - контейнер Docker, главным образом для того, чтобы пользоваться в разных средах разработки

● мобильное приложение c версиями для Android и iOS - контейнер Docker, оченбь сильно упрощает разработку и поддержку ПО. Так же нет необходимости в установке доп. софта.

● шина данных на базе Apache Kafka - про шину ничего не могу сказать, но для Kafka можно использовать контейнер Docker с необходимым для его работы  Zookeeper и стартом последнего всегда первым.

● Elasticsearch-кластер для реализации логирования продуктивного веб-приложения — три ноды elasticsearch, два logstash и две ноды kibana - наверняка сказать не могу, данные технологии не изучал, но если смотреть поверхностно, то скорее всего тут нужно железо, так как необходимо обеспечить высокую отказоустойчивость и быструю обработку данных.

● мониторинг-стек на базе Prometheus и Grafana - контейнер Docker легкое управление большим стеком Prometheus, Grafana, cAdvisor, NodeExporter и AlertManager.

● MongoDB как основное хранилище данных для Java-приложения - если сильнонагруженная и нужна скорость обработки данных, то железо. А так можно использовать контейнер Docker для того, чтобы не зависить от настроек хоста.

● Gitlab-сервер для реализации CI/CD-процессов и приватный (закрытый) Docker Registry - можно на виртуальной машине, елси не сильно большая будет нагрузка, то можно обойтись контейнером.




**Задача 3**.	
```
nolar@nolar-dev:~$ docker run -it -v /home/nolar/data:/data -d "centos:latest"
f461703ff5e446d891ad52990c40f6e76bd906c9e4ed6ceea2149a3b768831f6
nolar@nolar-dev:~$ docker exec -it f461703ff5e446d891ad52990c40f6e76bd906c9e4ed6ceea2149a3b768831f6  /bin/bash
[root@f461703ff5e4 /]# cd data
[root@f461703ff5e4 data]# touch file1
[root@f461703ff5e4 data]# ls
file1

```
```
nolar@nolar-dev:~$ cd data
nolar@nolar-dev:~/data$ touch file2
nolar@nolar-dev:~/data$ ls
file1  file2

```
```
nolar@nolar-dev:~$ docker run -it -v /home/nolar/data:/data -d "debian:latest"
2369cb5a1a51a3c045cfd02078c117d46d8df2fa8ec842e33a840e94eb70116a
nolar@nolar-dev:~$ docker exec -it 2369cb5a1a51a3c045cfd02078c117d46d8df2fa8ec842e33a840e94eb70116a  /bin/bash
root@2369cb5a1a51:/# cd data
root@2369cb5a1a51:/data# ls
file1  file2
```