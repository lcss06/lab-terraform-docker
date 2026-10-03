output "urls" {
  value = {
    web = "http://localhost:${var.puerto_web}"
    api = "http://localhost:${var.puerto_api}"
    bd  = "localhost:${var.puerto_bd}"
  }
}
