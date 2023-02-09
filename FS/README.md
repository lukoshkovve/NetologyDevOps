# Домашнее задание к занятию "Файловые системы"
**1**.

Разраяженные файлы, это специальный формат представления, в котором часть цифровой последовательности заменена сведениями о ней, что позволяет гораздо эфективнее задействовать возможности файловой системы. Из плюсов можно выделить то, что область файла будет увеличиватья по мере записи файла что экономит как место так и скорость записи. Из недостатков - совместимость.

Один из способов создания такого файла:
```
truncate –s2G file-sparse
```
**2**.	

Нет не могут, потому что жесткая ссылка и файл, для которого она создавалась, имеют одинаковые индексы (inode) в файловой системе.


**3**.	

Создались диски dev/sdb и dev/sdc
```
vagrant@sysadm-fs:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    2G  0 part /boot
└─sda3                      8:3    0   62G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
sdc                         8:32   0  2.5G  0 disk
```


**4**.	
```

sudo fdisk /dev/sdb


Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-5242879, default 2048): 2048
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2): 2
First sector (4196352-5242879, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):

Created a new partition 2 of type 'Linux' and of size 511 MiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

**5**.	
```
sudo sfdisk -d /dev/sdb | sfdisk /dev/sdc
```
```
vagrant@sysadm-fs:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    2G  0 part /boot
└─sda3                      8:3    0   62G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
└─sdb2                      8:18   0  511M  0 part
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
└─sdc2                      8:34   0  511M  0 part
```


**6**.

```
sudo mdadm --create --verbose /dev/md2 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
```

**7**.
```
sudo mdadm --create --verbose /dev/md3 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
```
**8**.
```
vagrant@sysadm-fs:~$ sudo pvcreate /dev/md2
  Physical volume "/dev/md2" successfully created.

vagrant@sysadm-fs:~$ sudo pvcreate /dev/md3
  Physical volume "/dev/md3" successfully created.
  ```
  **9**.
  ```
   sudo vgcreate vg-vmdisks /dev/md2 /dev/md3
  ```
 **10**.
 ```
  sudo lvcreate -L 100m -n lv-vmdisks vg-vmdisks /dev/md3
  ```
  **11**.
  ```
  sudo mkfs.ext4 /dev/mapper/vg--vmdisks-lv--vmdisks
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```
**12**.
```
vagrant@sysadm-fs:~$ mkdir /tmp/new
vagrant@sysadm-fs:~$ sudo mount /dev/mapper/vg--vmdisks-lv--vmdisks /tmp/new/
```
**13**.
```
vagrant@sysadm-fs:/tmp/new$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2023-02-09 21:41:31--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 24724777 (24M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz              100%[=================================================>]  23.58M  4.52MB/s    in 5.3s

2023-02-09 21:41:37 (4.45 MB/s) - ‘/tmp/new/test.gz’ saved [24724777/24724777]
```
**14**.
```
vagrant@sysadm-fs:/tmp/new$ lsblk
NAME                          MAJ:MIN RM  SIZE RO 
sda                             8:0    0   64G  0 disk
├─sda1                          8:1    0    1M  0 part
├─sda2                          8:2    0    2G  0 part  /boot
└─sda3                          8:3    0   62G  0 part
  └─ubuntu--vg-ubuntu--lv     253:0    0   31G  0 lvm   /
sdb                             8:16   0  2.5G  0 disk
├─sdb1                          8:17   0    2G  0 part
│ └─md2                         9:2    0    2G  0 raid1
└─sdb2                          8:18   0  511M  0 part
  └─md3                         9:3    0 1018M  0 raid0
    └─vg--vmdisks-lv--vmdisks 253:1    0  100M  0 lvm   /tmp/new
sdc                             8:32   0  2.5G  0 disk
├─sdc1                          8:33   0    2G  0 part
│ └─md2                         9:2    0    2G  0 raid1
└─sdc2                          8:34   0  511M  0 part
  └─md3                         9:3    0 1018M  0 raid0
    └─vg--vmdisks-lv--vmdisks 253:1    0  100M  0 lvm   /tmp/new
```
**15**.
```
vagrant@sysadm-fs:/tmp/new$ gzip -t /tmp/new/test.gz
vagrant@sysadm-fs:/tmp/new$ echo $?
0 
```
**16**.
```
vagrant@sysadm-fs:/tmp/new$ sudo pvmove -n lv-vmdisks /dev/md3 /dev/md2
  /dev/md3: Moved: 48.00%
  /dev/md3: Moved: 100.00%
```
**17**.
```
vagrant@sysadm-fs:/tmp/new$ sudo mdadm --fail /dev/md2 /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md2
```
**18**.
```
[10597.269874] md/raid1:md2: Disk failure on sdb1, disabling device.
md/raid1:md2: Operation continuing on 1 devices.
```
**19**.
```
vagrant@sysadm-fs:/tmp/new$ gzip -t /tmp/new/test.gz
vagrant@sysadm-fs:/tmp/new$ echo $?
0
```
**20**.
```
vagrant@sysadm-fs:~$ exit
logout
Connection to 127.0.0.1 closed.
```