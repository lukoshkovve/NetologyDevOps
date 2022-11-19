# NetologyDevOps
1. Игнорировать все файлы с расширением .teraform во всех каталогах, а также ингорировать следующий каталог
 
**/.terraform/*

2. Игнорировать все файлы с расширением .tfstate и другие расшиения

*.tfstate

*.tfstate.*

 3. Игнорировать crash.log и все другие файлы с расширением .log
 
crash.log

crash.*.log


 4. Игнорировать все файлы с расширением *.tfvars и и с расширением *.tfvars.json
 
*.tfvars

*.tfvars.json


 5. Игнорировать override.tf и override.tf.json а так же файлы которые заканчиваются на _override.tf и _override.tf.json
 
override.tf

override.tf.json

*_override.tf

*_override.tf.json


 6. Игнорировать каталог .terraformrc и файлы terraform.rc
 
.terraformrc

terraform.rc
