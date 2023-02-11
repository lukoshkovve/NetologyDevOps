# Домашнее задание к занятию "Компьютерные сети. Лекция 1"
**1**.
```
vagrant@vagrant:~$ telnet stackoverflow.com 80
Trying 151.101.1.69...
Connected to stackoverflow.com.
Escape character is '^]'.
GET /questions HTTP/1.0
HOST: stackoverflow.com

HTTP/1.1 403 Forbidden
Connection: close
Content-Length: 1917
Server: Varnish
Retry-After: 0
Content-Type: text/html
Accept-Ranges: bytes
Date: Sat, 11 Feb 2023 18:51:05 GMT
Via: 1.1 varnish
X-Served-By: cache-hel1410028-HEL
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1676141465.178821,VS0,VE2
X-DNS-Prefetch-Control: off

``` 
Получаю ошибку 403 - ограничение или отсутствие доступа. По большому счету, мой запрос удаленный хост понял но не авторизовал. 



**2**.	
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Network1/foto/1.JPG)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Network1/foto/2.JPG)

Дольше всего грузилась начальная страница - 371мс
**3**.	
```
vagrant@vagrant:~$ nslookup myip.opendns.com. resolver1.opendns.com
Server:         resolver1.opendns.com
Address:        208.67.222.222#53

Non-authoritative answer:
Name:   myip.opendns.com
Address: 46.22.xx.xx
```

**4**.	
```
vagrant@vagrant:~$ whois 46.22.xx.xx
% This is the RIPE Database query service.
% The objects are in RPSL format.
%
% The RIPE Database is subject to Terms and Conditions.
% See http://www.ripe.net/db/support/db-terms-conditions.pdf

% Note: this output has been filtered.
%       To receive output for a database update, use the "-B" flag.

% Information related to '46.22.xx.0 - 46.22.xx.255'

% Abuse contact for '46.22.xx.0 - 46.22.xx.255' is 'abuse@reconn.ru'

inetnum:        46.22.xx.0 - 46.22.xx.255
netname:        GranLine-46-55
org:            ORG-GI68-RIPE
country:        RU
admin-c:        SGZ11-RIPE
tech-c:         SGZ11-RIPE
status:         ASSIGNED PA
mnt-by:         RECONN-MNT
created:        2020-10-11T14:57:19Z
last-modified:  2020-10-11T15:02:35Z
source:         RIPE
```
**netname:        GranLine-46-55**
```
vagrant@vagrant:~$ dig $(dig -x 46.22.xx.xx | grep PTR | tail -n 1 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}').origin.asn.cymru.com TXT +short
"12722 | 46.22.48.0/20 | RU | ripencc | 2010-11-23"
```
**AS провайдера – #12722**

**5**.	

```
vagrant@vagrant:~$ sudo traceroute -IAn 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  10.0.2.2 [*]  1.954 ms  1.955 ms  1.955 ms
 2  192.168.31.1 [*]  6.351 ms  6.834 ms  7.522 ms
 3  192.168.4.104 [*]  7.934 ms  7.934 ms  8.334 ms
 4  195.209.44.209 [AS12722]  8.334 ms  8.334 ms  8.334 ms
 5  195.209.45.255 [AS12722]  8.334 ms  8.334 ms  8.334 ms
 6  142.250.47.108 [AS15169]  8.631 ms  6.868 ms  9.669 ms
 7  108.170.250.33 [AS15169]  5.940 ms  4.195 ms  4.329 ms
 8  108.170.250.34 [AS15169]  3.598 ms  3.292 ms  3.379 ms
 9  142.251.238.82 [AS15169]  20.888 ms  21.220 ms  21.394 ms
10  142.251.238.72 [AS15169]  20.684 ms  21.131 ms  20.531 ms
11  142.250.56.221 [AS15169]  23.106 ms  22.470 ms  25.521 ms
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * *
23  8.8.8.8 [AS15169/AS263411]  25.289 ms  21.705 ms  22.193 ms
```


**6**.	

```
vagrant@vagrant:~$ mtr 8.8.8.8 -znrc 1
Start: 2023-02-11T19:42:27+0000
HOST: vagrant                     Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS???    10.0.2.2             0.0%     1    8.0   8.0   8.0   8.0   0.0
  2. AS???    192.168.31.1         0.0%     1    4.0   4.0   4.0   4.0   0.0
  3. AS???    192.168.4.104        0.0%     1    0.0   0.0   0.0   0.0   0.0
  4. AS12722  195.209.44.209       0.0%     1    0.0   0.0   0.0   0.0   0.0
  5. AS12722  195.209.45.255       0.0%     1   15.3  15.3  15.3  15.3   0.0
  6. AS15169  142.250.47.108       0.0%     1    3.7   3.7   3.7   3.7   0.0
  7. AS15169  108.170.250.33       0.0%     1    7.1   7.1   7.1   7.1   0.0
  8. AS15169  108.170.250.34       0.0%     1    4.6   4.6   4.6   4.6   0.0
  9. AS15169  142.251.238.82       0.0%     1   28.8  28.8  28.8  28.8   0.0
 10. AS15169  142.251.238.72       0.0%     1   22.5  22.5  22.5  22.5   0.0
 11. AS15169  142.250.56.221       0.0%     1   23.4  23.4  23.4  23.4   0.0
 12. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 13. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 14. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 15. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 16. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 17. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 18. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 19. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 20. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 21. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 22. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 23. AS15169  8.8.8.8              0.0%     1   23.1  23.1  23.1  23.1   0.0
```
Самая большая задержка на 9 хопе


**7**.
```
vagrant@vagrant:~$ dig dns.google NS +noall +answer
dns.google.             7116    IN      NS      ns2.zdns.google.
dns.google.             7116    IN      NS      ns4.zdns.google.
dns.google.             7116    IN      NS      ns1.zdns.google.
dns.google.             7116    IN      NS      ns3.zdns.google.
 ```
```
vagrant@vagrant:~$ dig dns.google A +noall +answer
dns.google.             24      IN      A       8.8.4.4
dns.google.             24      IN      A       8.8.8.8
```
**8**.
```
vagrant@vagrant:~$ dig -x 8.8.4.4

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.4.4
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 14961
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;4.4.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
4.4.8.8.in-addr.arpa.   1020    IN      PTR     dns.google.

;; Query time: 20 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Sat Feb 11 19:56:44 UTC 2023
;; MSG SIZE  rcvd: 73
```
4.4.8.8.in-addr.arpa.   1020    IN      PTR     dns.google.
```
vagrant@vagrant:~$ dig -x 8.8.8.8

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.8.8
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 15385
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;8.8.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.   6108    IN      PTR     dns.google.

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Sat Feb 11 19:56:28 UTC 2023
;; MSG SIZE  rcvd: 73
```
8.8.8.8.in-addr.arpa.   6108    IN      PTR     dns.google.