# Imagenes descargadas desde Docker Hub
resource "docker_image" "nginx" {
  name         = var.imagen_web
  keep_locally = true
}

resource "docker_image" "node" {
  name         = var.imagen_api
  keep_locally = true
}

resource "docker_image" "postgres" {
  name         = var.imagen_bd
  keep_locally = true
}

# Un modulo por cada ambiente definido en terraform.tfvars (dev y qa)
module "ambiente" {
  source   = "./modules/ambiente"
  for_each = var.ambientes

  ambiente   = each.key
  puerto_web = each.value.puerto_web
  puerto_api = each.value.puerto_api
  puerto_bd  = each.value.puerto_bd

  imagen_web = docker_image.nginx.image_id
  imagen_api = docker_image.node.image_id
  imagen_bd  = docker_image.postgres.image_id

  db_user     = var.db_user
  db_password = var.db_password
  db_name     = var.db_name

  ruta_app = "${path.root}/../app"
}
