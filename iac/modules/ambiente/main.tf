# Red propia para que los contenedores del ambiente se vean por nombre
resource "docker_network" "red" {
  name = "red-${var.ambiente}"
}

resource "docker_volume" "datos_bd" {
  name = "datos-bd-${var.ambiente}"
}

# ---------- Base de datos ----------
resource "docker_container" "bd" {
  name    = "bd-${var.ambiente}"
  image   = var.imagen_bd
  restart = "unless-stopped"

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}",
  ]

  ports {
    internal = 5432
    external = var.puerto_bd
  }

  volumes {
    volume_name    = docker_volume.datos_bd.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.red.name
  }
}

# ---------- Backend ----------
resource "docker_container" "api" {
  name        = "api-${var.ambiente}"
  image       = var.imagen_api
  restart     = "unless-stopped"
  working_dir = "/app"
  command     = ["sh", "-c", "npm install --omit=dev && node index.js"]

  env = [
    "PORT=3000",
    "AMBIENTE=${var.ambiente}",
    "DB_HOST=${docker_container.bd.name}",
    "DB_PORT=5432",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
    "DB_NAME=${var.db_name}",
  ]

  upload {
    content = file("${var.ruta_app}/backend/package.json")
    file    = "/app/package.json"
  }

  upload {
    content = file("${var.ruta_app}/backend/index.js")
    file    = "/app/index.js"
  }

  ports {
    internal = 3000
    external = var.puerto_api
  }

  networks_advanced {
    name = docker_network.red.name
  }
}

# ---------- Frontend ----------
resource "docker_container" "web" {
  name    = "web-${var.ambiente}"
  image   = var.imagen_web
  restart = "unless-stopped"

  # el navegador llama al backend por el puerto publicado en el host
  upload {
    content = templatefile("${var.ruta_app}/frontend/index.html", {
      ambiente = var.ambiente
      api_url  = "http://localhost:${var.puerto_api}"
    })
    file = "/usr/share/nginx/html/index.html"
  }

  ports {
    internal = 80
    external = var.puerto_web
  }

  networks_advanced {
    name = docker_network.red.name
  }

  depends_on = [docker_container.api]
}
