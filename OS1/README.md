# Домашнее задание к занятию "Операционные системы 1"
**1**.
```
 	strace 2>log /bin/bash -c 'cd /tmp' &&  grep tmp log

     chdir("/tmp")      = 0
     
```
**2**.	Из file man
FILES
   /usr/share/misc/magic.mgc  Default compiled list of magic.

/usr/share/misc/magic      Directory containing default magic files.

```
vagrant@vagrant:~$ strace 2>log1 file -c  &&  grep magic log1
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
stat("/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
```

Вот все обращения к файлам и библиотекам.

**3**.	Запустим 
```
top > log5
```
Убьём файл 
```
sudo rm log5
```
```
vagrant@vagrant:/$ sudo lsof | grep log5

top       2908                        vagrant    1w      REG              253,0  9209631    1316983 /home/vagrant/log5 (deleted)

```
Видим, что PID = 2522 и дескриптор 1
```
vagrant@vagrant:/$ echo -n ''> /proc/2908/fd/1
vagrant@vagrant:/$ sudo lsof | grep log5
top       2908                        vagrant    1w      REG              253,0        0    1316983 /home/vagrant/log5 (deleted)
```
**4**.	Это несуществующие процессы, которые занимают место в таблице системных процессов. Как видно из запроса ниже, CPU и mem они не потребляют.
```
root@vagrant:/home/vagrant# ps aux | grep defunct
root        3389  0.0  0.0   6432   656 pts/2    S+   20:50   0:00 grep --color=auto defunct
```
**5**.	
```
vagrant@vagrant:~$ sudo /usr/sbin/opensnoop-bpfccpermitted

PID    COMM               FD ERR PATH

884    vminfo              4   0 /var/run/utmpin <module>
666    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
666    dbus-daemon        21   0 /usr/share/dbus-1/system-services in __init__
666    dbus-daemon        -1   2 /lib/dbus-1/system-services_file or "<text>")
666    dbus-daemon        21   0 /var/lib/snapd/dbus-1/system-services/
884    vminfo              4   0 /var/run/utmp
666    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
666    dbus-daemon        21   0 /usr/share/dbus-1/system-services
666    dbus-daemon        -1   2 /lib/dbus-1/system-services
666    dbus-daemon        21   0 /var/lib/snapd/dbus-1/system-services/
```



**6**.	
```
uname -a  
```
 выводит информацию о системе в целом и в том числе ядре.
SYNOPSIS
       uname [OPTION]...

DESCRIPTION
       Print certain system information.  With no OPTION, same as -s.

 -a, --all
print all information, in the following order

Альтернатива
```
 cat /proc/version
```

**7**.	Это операторы управления
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




