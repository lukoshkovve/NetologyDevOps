# Домашнее задание к занятию "Компьютерные сети. Лекция 2"
**1**.

Для Windows

```
C:\Users\User>ipconfig /all
``` 
Для Linux
```
vagrant@vagrant:~$ ifconfig
```


**2**.	

LLDP – протокол для обмена информацией между соседними устройствами.

Пакет
```
sudo apt install lldpd
```
Команда 
```
lldpctl
```


**3**.

Технология VLAN

Пакет
```
sudo apt-get install vlan
```
Настойка производиться в файле */etc/network/interfaces*
```
auto vlan1400
iface vlan1400 inet static
        address 192.168.1.1
        netmask 255.255.255.0
        vlan_raw_device eth0

```


**4**.

В Linux две технологии LAG - bonding и teaming

Команды используемые в режиме балансировки нагрузки:

 ---------
|Название       | код |Описание                    |
| ------------- |:---:| :--------------------------:|
| balance-rr    | 0 | Отправка сетевых пакетов поочередно через все агрегированные интерфейсы (политика round-robin) |
| balance-xor     | 2      |   Передача сетевых пакетов распределяются между интерфейсами на основе формулы (могут использоваться MAC-адрес, IP-адреса или номера IP-портов).Один и тот же интерфейс работает с определенным получателем. |
| balance-tlb | 5      |    Входящие сетевые пакеты принимаются только активным сетевым интерфейсом, исходящие распределяется в зависимости от текущей загрузки каждого интерфейса. |
| balance-alb | 6      |   Исходящие сетевые пакеты распределяется между интерфейсами, входящие сетевые пакеты принимаются всеми интерфейсами. |
----------------------------

- Для использования режимов balance-rr, balance-xor и broadcast на коммутаторе сети должен быть настроено статическое объединение портов (static port trunking).

- Для использования режима balance-alb требуются сетевые карты, поддерживающие смену MAC-адреса.

Пример конфига для для код = 0

*/etc/network/interfaces*

```
auto bond0
iface bond0 inet static
    address 10.0.2.6
    netmask 255.255.255.0    
    gateway 10.0.2.1
    dns-nameservers 10.0.2.1
    dns-search domain.local
        slaves eth0 eth1
        bond_mode 0
        bond-miimon 100
        bond_downdelay 200
        bound_updelay 200
```




**5**.	

```
vagrant@sysadm-fs:~$ ipcalc -b 10.0.2.1/29
Address:   10.0.2.1
Netmask:   255.255.255.248 = 29
Wildcard:  0.0.0.7
=>
Network:   10.0.2.0/29
HostMin:   10.0.2.1
HostMax:   10.0.2.6
Broadcast: 10.0.2.7
Hosts/Net: 6
```
в /29 сети 6 хостов, 1 адрес сети и 1 щироковещательный
Сеть /24 разбивается на 32 подсети с масой /29

**6**.	

Здесь подойдет сеть 10.64.0.0/10

```
1. Requested size: 30 hosts
Netmask:   255.255.255.224 = 27
Network:   100.64.0.0/27
HostMin:   100.64.0.1
HostMax:   100.64.0.30
Broadcast: 100.64.0.31
Hosts/Net: 30                    Class A
```
При условии, что не более 50 адресов, подойдет сеть с маской /27

Чтобы вместилось 50 адресов, необходимо использовать сеть с маской /26
```
1. Requested size: 50 hosts
Netmask:   255.255.255.192 = 26
Network:   10.0.0.0/26
HostMin:   10.0.0.1
HostMax:   10.0.0.62
Broadcast: 10.0.0.63
Hosts/Net: 62                    Class A, Private Internet
```


**7**.


 ---------
|| Linux |Windows                    |
| -------------------- |:--------------------:| :-----------------|
| Проверить arp-таблицу  |    ip neigh, arp -n      | arp -a |
| Очистить кэш так    | ip neigh flush      |   arp -d |
| Удалить один IP | arp -d IP; ip neigh delete IP dev INTERFACE      |    arp -d IP |

----------------------------
