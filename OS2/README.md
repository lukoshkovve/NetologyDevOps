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
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/OS2/foto/metrics.JPG)


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

**6**.	
В первом терминале:
```
vagrant@vagrant:~$ sudo su
root@vagrant:/home/vagrant# unshare -f --pid --mount-proc sleep 1h
^Z
[1]+  Stopped                 unshare -f --pid --mount-proc sleep 1h
root@vagrant:/home/vagrant# bg
[1]+ sudo unshare -f --pid --mount-proc sleep 1h &
```
Во втором терминале:
```
root@vagrant:/# ps aux | grep sleep
root        2150  0.0  0.0   5476   584 pts/0    S    20:11   0:00 sleep 1h
root        2414  0.1  0.0   6432   656 pts/1    T    20:22   0:00 grep --color=auto sleep
```
```
root@vagrant:/# nsenter --target 2150 --pid --mount
```
```
root@vagrant:/# ps -aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   5476   520 pts/0    S+   20:29   0:00 sleep 1h
root           2  0.1  0.2   7236  4252 pts/1    S    20:31   0:00 -bash
root          20  0.0  0.1   9080  3700 pts/1    R+   20:32   0:00 ps -aux
```

**7**.
	**:(){ :|:& };:** - fork бомба. Функция bush которая вызывает себя рекурсивно, что перегружает ресурсы ПК в плоть до того, что он перастает отвечать.
```
   :(){ :|:& };:
\_/| |||| ||\- ... the function ':', initiating a chain-reaction: each ':' will start    two more.
 | | |||| |\- Definition ends now, to be able to run ...
 | | |||| \- End of function-block
 | | |||\- disown the functions (make them a background process), so that the children    of a parent
 | | |||   will not be killed when the parent gets auto-killed
 | | ||\- ... another copy of the ':'-function, which has to be loaded into memory.
 | | ||   So, ':|:' simply loads two copies of the function, whenever ':' is called
 | | |\- ... and pipe its output to ...
 | | \- Load a copy of the function ':' into memory ...
 | \- Begin of function-definition
 \- Define the function ':' without any parameters '()' as follows:
 ```
