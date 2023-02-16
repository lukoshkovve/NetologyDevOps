# Домашнее задание к занятию "Операционные системы лекция 2"
**1**.
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/SEC/foto/1.JPG)


**2**.	

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/SEC/foto/2.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/SEC/foto/3.JPG)


**3**.	

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/SEC/foto/4.JPG)

Сделал как в презентации
```
sudo apt install apache2
sudo a2enmod ssl
sudo systemctl restart apache2sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \-keyout /etc/ssl/private/apache-selfsigned.key \-out /etc/ssl/certs/apache-selfsigned.crt \-subj "/C=RU/ST=Moscow/L=Moscow/O=Company Name/OU=Org/CN=www.example.com"
sudo nano /etc/apache2/sites-available/mysite.conf
<VirtualHost *:443>   
ServerName mysite.com
DocumentRoot /var/www/mysite.com
SSLEngine on   SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt   
SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key</VirtualHost>sudo 
mkdir /var/www/mysite.com
sudo nano /var/www/mysite.com/index.html
<h1>it worked!</h1>
sudo a2ensite mysite.com
```

**4**.	
```
vagrant@vagrant:~$ git clone --depth 1 https://github.com/drwetter/testssl.sh.git

vagrant@vagrant:~/testssl.sh$ ./testssl.sh -U --sneaky https://google.com

###########################################################
    testssl.sh       3.2rc2 from https://testssl.sh/dev/
    (e57527f 2023-02-08 17:07:42)

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.0.2-bad (1.0.2k-dev)" [~183 ciphers]
 on vagrant:./bin/openssl.Linux.x86_64
 (built: "Sep  1 14:03:44 2022", platform: "linux-x86_64")


Testing all IPv4 addresses (port 443): 142.250.147.102 142.250.147.101 142.250.147.139 142.250.147.113 142.250.147.100 142.250.147.138
--------------------------------------------------------------------------------
 Start 2023-02-15 20:36:33        -->> 142.250.147.102:443 (google.com) <<--

 Further IP addresses:   142.250.147.138 142.250.147.100 142.250.147.113 142.250.147.139 142.250.147.101
                         2a00:1450:4010:c07::71 2a00:1450:4010:c07::66 2a00:1450:4010:c07::8a 2a00:1450:4010:c07::64
 rDNS (142.250.147.102): rd-in-f102.1e100.net.
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    no gzip/deflate/compress/br HTTP compression (OK)  - only supplied "/" tested
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services, see
                                           https://search.censys.io/search?resource=hosts&virtual_hosts=INCLUDE&q=6C28D173E3123E188102A25AA87CBC005512FC894DF7E0076CA057ECC67DA967
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
 BEAST (CVE-2011-3389)                     TLS1: ECDHE-ECDSA-AES128-SHA ECDHE-ECDSA-AES256-SHA ECDHE-RSA-AES128-SHA
                                                 ECDHE-RSA-AES256-SHA AES128-SHA AES256-SHA DES-CBC3-SHA
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2023-02-15 20:37:14 [  43s] -->> 142.250.147.102:443 (google.com) <<--

```

**5**.	

```
vagrant@vagrant:~$ systemctl status sshd
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2023-02-15 16:52:16 UTC; 24h ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 957 (sshd)
      Tasks: 1 (limit: 2273)
     Memory: 5.5M
     CGroup: /system.slice/ssh.service
             └─957 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
```
```
vagrant@vagrant:~$ ssh-keygen
ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/vagrant/.ssh/id_rsa
Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:RBqFroIWjU9lSM4T9PO7bRhjkAosfVMDaMT73aT8gJiznc vagrant@vagrant
The key's randomart image is:
+---[RSA 3072]----+
|  o+...==        |
|  oo0o+==..       |
|  o+***..        |
| o =..*=  .      |
| .+o.0o =S+       |
|..=.o oo.= .      |
|.  + . uE..       |
|    . . +.       |
|       ...       |
+----[SHA256]-----+
```
```
vagrant@vagrant:~$ ssh-copy-id -i .ssh/id_rsa vagrant@10.0.2.15
vagrant@vagrant:~$ ssh vagrant@10.0.2.15
Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-135-generic x86_64)
```
**6**.	

```
vagrant@vagrant:~$ sudo mv ~/.ssh/id_rsa ~/.ssh/id_rsa_mysite
vagrant@vagrant:~$ sudo nano ~/.ssh/config
Host mysite
        HostName 10.0.2.15
        User vagrant
        Port 22
        IdentityFile ~/.ssh/id_rsa_mysite
         
vagrant@vagrant:~$ ssh mysite
Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-135-generic x86_64)
```
**7**.
```
vagrant@vagrant:~$ sudo tcpdump -i eth0 -c 100 -w icmp.pcap
```	
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/SEC/foto/5.JPG)
