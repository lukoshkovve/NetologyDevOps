# Домашнее задание к занятию 1. «Типы и структура СУБД»
**Задание 1**.

>Электронные чеки в json виде 

Больше всего подойдет документоориентированная база данных mongodb
>Склады и автомобильные дороги для логистической компании

Подойдут графовые базы данных, так как они основаны на топографической структуре сети и представляют собой наборы узлов, ребер и свойств.
>генеалогические деревья

Как и в предыдущем случае можно использовать базы данных теоретико-графовой модели в частности сетевую базу данных, где так же используются узлы и ребра которыми можно представить генеологическое дерево.

>кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации

База данных NoSQL, в которой могут храниться только пары «ключ-значение» такие как DynamoDB и Redis, таким образом для каждого клиента (ключ) можно задать значение (ID сессии аунтификации)

>отношения клиент-покупка для интернет-магазина

Так как предпологается, что будет много связей клиента со всевозможными товарами, данными клиента и.т.д подойдет реалиционная база данных.


**Задание 2**.	

>данные записываются на все узлы с задержкой до часа (асинхронная запись)

*CAP* - CA, *PACELC* - PC/EL
>При сетевых сбоях, система может разделиться на 2 раздельных кластера

*CAP* - AP, *PACELC* - PA/EL

>Система может не прислать корректный ответ или сбросить соединение

*CAP* - CP, *PACELC* - PA/EC

**Задание 3**.	

Сочетаться не могут, т.к. согласованность данных при ACID происходит гарантированно и сразу же по завершении транзакции, а BASE не может гарантировать согласованность.

**Задание 4**.	

Система Redis Pub/Sub 

из минусов базы данных:

* RDB НЕ подходит, если вам нужно свести к минимуму вероятность потери данных в случае, если Redis перестанет работать (например, после отключения электроэнергии). Вы можете настроить различные точки сохранения , в которых создается RDB (например, после как минимум пяти минут и 100 операций записи в набор данных у вас может быть несколько точек сохранения). Однако вы обычно создаете моментальный снимок RDB каждые пять минут или чаще, поэтому в случае, если Redis перестанет работать без корректного завершения работы по какой-либо причине, вы должны быть готовы потерять последние минуты данных.
* RDB необходимо часто выполнять fork(), чтобы сохраняться на диске с помощью дочернего процесса. fork() может занимать много времени, если набор данных большой, и может привести к тому, что Redis перестанет обслуживать клиентов на несколько миллисекунд или даже на одну секунду, если набор данных очень большой, а производительность процессора невысокая. AOF также нуждается в fork(), но реже, и вы можете настроить, как часто вы хотите переписывать свои журналы без какого-либо компромисса с долговечностью.