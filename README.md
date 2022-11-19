# NetologyDevOps
# Игнорировать все файлы с расширением .teraform во всех каталогах, а также ингорировать следующий каталог
**/.terraform/*

# Игнорировать все файлы с расширением .tfstate и другие расшиения
*.tfstate
*.tfstate.*

# Игнорировать crash.log и все другие файлы с расширением .log
crash.log
crash.*.log


# Игнорировать все файлы с расширением *.tfvars и и с расширением *.tfvars.json
*.tfvars
*.tfvars.json


# Игнорировать override.tf и override.tf.json а так же файлы которые заканчиваются на _override.tf и _override.tf.json
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Игнорировать каталог .terraformrc и файлы terraform.rc
.terraformrc
terraform.rc
