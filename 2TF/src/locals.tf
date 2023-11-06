locals {
   project = "netology-develop-platform"
   env_web = "web"
   env_db = "db"
   web_instance = "${local.project}-${local.env_web}"
   db_instance = "${local.project}-${local.env_db}"
}