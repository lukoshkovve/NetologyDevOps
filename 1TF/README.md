# Домашнее задание к занятию "Введение в Terraform"
**1**.

Зависимости скачаны.

**2**.	

Хранить секреты необходимо в файле `personal.auto.tfvars` .gitignore не допустит попадания в коммит данный файл и секреты не попадут в репозиторий.

**3**.	

>"result": "nAOLzvi6ibIc56c5"

**4**.	
Было допущено 3 ошибки:
       1. ресурс образа докера не был указан;
       2. не правильно указано имя контейнера;
       3. при составлении имени использовались не корректные переменные. Такие переменные не были заданы.

**5**.	

![]([https://github.com/lukoshkovve/NetologyDevOps/main/TF1/foto/TF.JPG])

**6**.	

если terraform apply запустить с флагом -auto-approve то создастся план на основе изменений при этом не спрашивая разрешения у пользователя. Что может повлечь уничтожение данных. 

![]([https://github.com/lukoshkovve/NetologyDevOps/main/TF1/foto/TF.JPG2])

**7**.

![]([https://github.com/lukoshkovve/NetologyDevOps/main/TF1/foto/TF.JPG3)

**8**.

https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs/resources/image#:~:text=keep_locally%20(Boolean)%20If%20true%2C%20then%20the%20Docker%20image%20won%27t%20be%20deleted%20on%20destroy%20operation.%20If%20this%20is%20false%2C%20it%20will%20delete%20the%20image%20from%20the%20docker%20local%20storage%20on%20destroy%20operation.




