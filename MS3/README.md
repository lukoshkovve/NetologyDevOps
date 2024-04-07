# Домашнее задание к занятию «Микросервисы: подходы»

**Задача 1:**

За основу можно взять решение Gitlab. Данное решение закрывает почти все требования (кроме требования по безопасному хранению паролей и ключей доступа) которым должно соответствовать. Плюсом данного решения так же будет большое сообщество, отличая документация и с большой вероятностью все разработчики знакомы с Gitlab

Еще одно решение это инструмент для централизованного управления секретами - HashiCorp Vault. Такое решение обладает интуитивно понятным функционалом и можно достаточно быстро настроить хранение и управление конфиденциальной информацией.


**Задача 2:**

Здесь первостепенно выступает скилл команды в работе с тем или иным инструментом
Можно рассмотреть стек ELK и стек Clichouse, Vector и Lighthouse

ELK (Elasticsearch, Logstash, Kibana):
- на стороне клиента Beat следит за изменениями логов и пишет в Logstsash
- Logstash фильтрует и кладет их в  Elasticsearch
- Kibana показывает их в GUI

Clichouse, Vector и Lighthouse:

- Clichouse отвечает за хранение логов 
- Vector сбор логов и передача в хранилище
- Lighthouse выступает в качестве GUI


**Задача 3:**

Можно предложить стек Prometheus, Node Exporter и Grafana.

- Prometheus - выступает в качестве агрегатора метрик из сервисов в одном месте.
- Node Exporter - приложение которое собират метрики непосредственно на хосте который мониторим. Далее Prometheus их собирает.
- Grafana - отображает данные из  Prometheus в виде графиков.

Данный стек очень хорошо себя зарекомендовал как высокопроизводительное решение, а так же, стек очень популярен и имеет хорошую документацию. 