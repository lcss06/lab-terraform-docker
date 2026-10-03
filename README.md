# lab-terraform-docker

Levantar dos ambientes (DEV y QA) con Terraform y Docker. Cada ambiente tiene un frontend con nginx, un backend con node y una base de datos postgres, usando imagenes de Docker Hub.

| Ambiente | web (nginx) | api (node) | bd (postgres) |
|----------|-------------|------------|---------------|
| DEV      | 4001:80     | 4002:3000  | 4003:5432     |
| QA       | 5001:80     | 5002:3000  | 5003:5432     |

## Requisitos

- Docker Desktop corriendo
- Terraform

## Pasos

```bash
git clone https://github.com/lcss06/lab-terraform-docker.git
cd lab-terraform-docker/iac
terraform init
terraform apply
```

En Windows hay que pasarle el socket de docker:

```bash
terraform apply -var "docker_host=npipe:////.//pipe//docker_engine"
```

Para comprobar:

```bash
docker ps
```

- DEV: http://localhost:4001
- QA: http://localhost:5001

Para borrar todo:

```bash
terraform destroy
```
