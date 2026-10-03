variable "ambiente" {
  type = string
}

variable "puerto_web" {
  type = number
}

variable "puerto_api" {
  type = number
}

variable "puerto_bd" {
  type = number
}

variable "imagen_web" {
  type = string
}

variable "imagen_api" {
  type = string
}

variable "imagen_bd" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type = string
}

variable "ruta_app" {
  description = "Carpeta donde estan el frontend y el backend"
  type        = string
}
