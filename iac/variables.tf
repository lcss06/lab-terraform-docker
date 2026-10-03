variable "docker_host" {
  description = "Socket del daemon de Docker (cambia segun el sistema operativo)"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

variable "imagen_web" {
  description = "Imagen de Docker Hub para el frontend"
  type        = string
  default     = "nginx:alpine"
}

variable "imagen_api" {
  description = "Imagen de Docker Hub para el backend"
  type        = string
  default     = "node:20-alpine"
}

variable "imagen_bd" {
  description = "Imagen de Docker Hub para la base de datos"
  type        = string
  default     = "postgres:16-alpine"
}

variable "db_user" {
  type    = string
  default = "postgres"
}

variable "db_password" {
  type      = string
  default   = "postgres"
  sensitive = true
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "ambientes" {
  description = "Puertos externos de cada ambiente"
  type = map(object({
    puerto_web = number
    puerto_api = number
    puerto_bd  = number
  }))
}
