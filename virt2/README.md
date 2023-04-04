# Домашнее задание к занятию 2. «Применение принципов IaaC в работе с виртуальными машинами»
**Задача 1**.


||Преимущества применения на практике IaaC-паттернов| 
| -- | --- |
| ●  | Ускорение производства и выовда продукта на рынок |
| ●  | Стабильность среды, устранение дрейфа конфигураций |
| ●  | Эффективность и скорость разработки |
||

Основопологающим принципом laaC является идемпотентность. 

**Идемпотентность** — это свойство объекта
или операции, при повторном выполнении
которой мы получаем результат идентичный
предыдущему и всем последующим
выполнениям.

**Задача 2**.

> Чем Ansible выгодно отличается от других систем управление конфигурациями?

● работа инструмента выполняется через SSH;

● работа Ansible осуществляется в режиме Pull и Push;

● простота использования;

> Какой, на ваш взгляд, метод работы систем конфигурации более надёжный — push или pull?

На мой взгляд надежней метод *push* это обезопасит файлы конфигурации от постороннего вмешательства.  

**Задача 3**.	
> VirtualBox
```
nolar@nolar-dev:~/2$ vboxmanage --version
6.1.38_Ubuntur153438
```
> Vagrant
```
nolar@nolar-dev:~/2$ vagrant --version
Vagrant 2.2.6
```
> Terraform
```
nolar@nolar-dev:~$ terraform -v
Terraform v1.4.4
on linux_amd64
```


> Ansible
```
nolar@nolar-dev:~/2$ ansible --version
ansible 2.9.6
  config file = /home/nolar/2/ansible.cfg
  configured module search path = ['/home/nolar/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Jun 22 2022, 20:18:18) [GCC 9.4.0]
  ```

**Задача 4**.	
```
nolar@nolar-dev:~/2$ vagrant provision
==> server1.netology: Running provisioner: ansible...
Vagrant has automatically selected the compatibility mode '2.0'
according to the Ansible version installed (2.9.6).

Alternatively, the compatibility mode can be specified in your Vagrantfile:
https://www.vagrantup.com/docs/provisioning/ansible_common.html#compatibility_mode

    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.netology]

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=['git', 'curl'])

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
```
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

```
vagrant@server1:~$ docker --version
Docker version 23.0.2, build 569dd73
```
