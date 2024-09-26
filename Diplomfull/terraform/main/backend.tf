terraform {

  backend "s3" {
    endpoint = "https://storage.yandexcloud.net"
    bucket = "diplom-lukoshkov"
    region = "ru-central1"
    key    = "state/terraform.tfstate"
    access_key = ""
    secret_key = ""
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}