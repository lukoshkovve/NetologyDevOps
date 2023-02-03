# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"

1. 	Cd – команда которая встроена в оболочку bash, предназначение которой менять рабочий каталог. Если бы команда была внешней, то это был бы исполняемая команда, находящаяся в каталоге.  
1. /usr/bin/grep -c <some_string> <some_file>
1. systemd. Узнал через команду pstree –p 
1. . Открыл два терминала /dev/pts/0 и /dev/pts/1
На терминале “/dev/pts/0” ввел команду  ls  errorfile 2>/dev/pts/1
На терминале “/dev/pts/1” получил вывод “ ls: cannot access ' errorfile ': No such file or directory”

1. cat < file1 >file2
1. echo "hello" >/dev/tty
1. bash 5>&1 перенаправит fd 5 в текущее расположение stdout и следующая за ней команда echo netology > /proc/$$/fd/5, выведет в терминал слово “netology” потому что мы продолжаем находиться в fd 5
1. cat /home/vagrant/file1 2>&1 1>/dev/pts/1 | ls -l > error.txt

1. Команда env 
1. vagrant@vagrant:~$ cat /proc/2648/cmdline
bashvagrant@vagrant:~$    - выведет команду которой был запущен процесс. В данном случае bash 
vagrant@vagrant:~$ ls -l /proc/2648/exe
lrwxrwxrwx 1 vagrant vagrant 0 Feb  2 18:34 /proc/2648/exe -> /usr/bin/bash – Это символьная ссылкуа на абсолютную директорию запущенного бинарного файла. В данном случае bash


1. less /proc/cpuinfo | grep  "sse"
flags  : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 movbe popcnt aes rdrand hypervisor lahf_lm abm invpcid_single pti fsgsbase bmi1 bmi2 invpcid md_clear flush_l1d arch_capabilities
flags  : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 movbe popcnt aes rdrand hypervisor lahf_lm abm invpcid_single pti fsgsbase bmi1 bmi2 invpcid md_clear flush_l1d arch_capabilities
flags  : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 movbe popcnt aes rdrand hypervisor lahf_lm abm invpcid_single pti fsgsbase bmi1 bmi2 invpcid md_clear flush_l1d arch_capabilities

SSE 4.2


11. Соединение не будет установлено, потому что в списке аргументов передается явная команда, а TTY не выделяется для удаленного сеанса. Чтобы обойти это надо поставить -t 
vagrant@vagrant:~$ ssh -t localhost 'tty'
vagrant@localhost's password:
/dev/pts/2
Connection to localhost closed.

12. Нужно завершить процесс который мы хотим перенести и запустить его  в фоновом режиме  bg далее отречься от родительского процесса disown и выполнить команду screen и ввести reptyr PID (PID процесса который хотим перенести)
13. sudo echo string > /root/new_file не будет работать потому что будет выполняться под супер пользователем но > будет работать от текущего пользователя. (как вариант перед исполнением команды надо выполнить sudo su)
echo string | sudo tee /root/new_file – будет работать, потому что файлу для записи нужны права администратора и эта команда перепишет файл и выведет на экран.

 
 
