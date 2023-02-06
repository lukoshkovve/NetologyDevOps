# Домашнее задание к занятию "Операционные системы лекция 2"
**1**.
```
[Unit]
Description=Node Exporter Service


[Service]
User=nodeusr
Group=nodeusr
ExecStart=/usr/local/bin/node_exporter $MY_OPTS
EnvironmentFile=/etc/default/node_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target

```
Разрешаем автозапуск:
```
sudo enable node_exporter
```
После перезагрузки проверяем работу:

```
sudo systemctl status node_exporter
```
Видим, что все работает корректно

```
 	vagrant@vagrant:~$ sudo systemctl status node_exporter
● node_exporter.service - Node Exporter Service
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2023-02-06 18:39:05 UTC; 16s ago
   Main PID: 5448 (node_exporter)
      Tasks: 7 (limit: 2273)
     Memory: 2.4M
     CGroup: /system.slice/node_exporter.service
             └─5448 /usr/local/bin/node_exporter --log.level=info

Feb 06 18:39:05 vagrant node_exporter[5448]: level=info ts=2023-02-06T18:39:05.497Z caller=node_exporter.go:112 collector=thermal_zone
Feb 06 18:39:05 vagrant node_exporter[5448]: level=info ts=2023-02-06T18:39:05.497Z caller=node_exporter.go:112 collector=time
Feb 06 18:39:05 vagrant node_exporter[5448]: level=info ts=2023-02-06T18:39:05.497Z caller=node_exporter.go:112 collector=timex
Feb 06 18:39:05 vagrant node_exporter[5448]: level=info ts=2023-02-06T18:39:05.497Z caller=node_exporter.go:112 collector=udp_queues
Feb 06 18:39:05 vagrant node_exporter[5448]: level=info ts=2023-02-06T18:39:05.497Z caller=node_exporter.go:112 collector=uname
Feb 06 18:39:05 vagrant node_exporter[5448]: level=info ts=2023-02-06T18:39:05.497Z caller=node_exporter.go:112 collector=vmstat
Feb 06 18:39:05 vagrant node_exporter[5448]: level=info ts=2023-02-06T18:39:05.497Z caller=node_exporter.go:112 collector=xfs
Feb 06 18:39:05 vagrant node_exporter[5448]: level=info ts=2023-02-06T18:39:05.497Z caller=node_exporter.go:112 collector=zfs
Feb 06 18:39:05 vagrant node_exporter[5448]: level=info ts=2023-02-06T18:39:05.497Z caller=node_exporter.go:191 msg="Listening on" address=:9100
Feb 06 18:39:05 vagrant node_exporter[5448]: level=info ts=2023-02-06T18:39:05.497Z caller=tls_config.go:170 msg="TLS is disabled and it cannot be enabled on the fly." http2=false
     
```

**2**.	

Процессор
```
node_cpu_seconds_total{cpu="0",mode="idle"} 2805.23
node_cpu_seconds_total{cpu="0",mode="iowait"} 3.21
node_cpu_seconds_total{cpu="0",mode="irq"} 0
node_cpu_seconds_total{cpu="0",mode="nice"} 0.04
node_cpu_seconds_total{cpu="0",mode="softirq"} 0.96
node_cpu_seconds_total{cpu="0",mode="steal"} 0
node_cpu_seconds_total{cpu="0",mode="system"} 9.18
node_cpu_seconds_total{cpu="0",mode="user"} 4.61

```
Память
```
node_memory_Active_file_bytes
node_memory_Mapped
node_memory_MemFree
node_memory_SwapFree
node_memory_SwapTotal
```
Файловая система
```
node_filesystem_free
node_filesystem_size
```
Сеть
```
node_network_receive_bytes
node_network_receive_errs
node_network_transmit_bytes
node_network_transmit_errs

```




**3**.	
![](foto/metrics.jpg)


**4**.	
```
vagrant@vagrant:~$ sudo dmesg | grep "Hypervisor detected"
[    0.000000] Hypervisor detected: KVM
```

**5**.	
Значение лимита открытых файлов для каждого процесса можно посмотреть:
```
vagrant@vagrant:~$  cat /proc/sys/fs/nr_open
1048576  
```
Менять его можно добавив в  */etc/sysctl.conf* параметр  **fs.nr_open** равный необходимому значению. 

Например **fs.nr_open = 96000**

```
vagrant@vagrant:~$ cat /proc/sys/fs/nr_open
96000
```

**6**.	Это операторы управления
Точка с запятой (;)  - команда будет исполняться до момента достижения этого символа, далее будет исполнена другая команда, которая идет после ; 
Двойной амперсанд (&&) выступает как логическая И и вторая команда будет исполнена только после того, как успешно исполнится первая команда.
set -e будет работать в нашем примере, так как завершит работу при обработке test -d /tmp/some_dir

**8**.	SET

**-e** скрипт немедленно завершит работу, если любая команда выйдет с ошибкой.

**-o** pipefail  Если нужно убедиться, что все команды в пайпах завершились успешно

**-u** оболочка проверяет инициализацию переменных в скрипте. Если переменной не будет, скрипт немедленно завершиться.

**-x** bash печатает в стандартный вывод все команды перед их исполнением.

**9**. 
```
vagrant@vagrant:~$ ps -o stat
STAT
Ss
R+
```
Т.к. система совсем пустая, точно нельзя сказать каких больше.
Дополнительные буквы:
<    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group




