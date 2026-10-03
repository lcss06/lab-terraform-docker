output "ambientes" {
  description = "URLs de acceso de cada ambiente"
  value       = { for nombre, amb in module.ambiente : nombre => amb.urls }
}
