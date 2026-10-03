# Lab Terraform - Ambientes DEV y QA con Docker

Infraestructura como código con **Terraform** y el provider de **Docker**. Se levantan dos ambientes (DEV y QA), cada uno con tres contenedores usando imágenes oficiales de Docker Hub:

| Servicio | Imagen (Docker Hub)  | DEV          | QA           |
|----------|----------------------|--------------|--------------|
| Frontend | `nginx:alpine`       | `web-dev` 4001:80   | `web-qa` 5001:80   |
| Backend  | `node:20-alpine`     | `api-dev` 4002:3000 | `api-qa` 5002:3000 |
| BD       | `postgres:16-alpine` | `bd-dev` 4003:5432  | `bd-qa` 5003:5432  |

Flujo: `Frontend (nginx) -> Backend (node) -> Base de datos (postgresql)`

Cada ambiente tiene su propia red de Docker (`red-dev`, `red-qa`) y su propio volumen para los datos de postgres.

## Estructura

```
.
├── app
│   ├── backend
│   │   ├── index.js        # API en node (puerto 3000)
│   │   └── package.json
│   └── frontend
│       └── index.html      # pagina servida por nginx
└── iac
    ├── providers.tf        # provider de docker
    ├── variables.tf
    ├── terraform.tfvars    # puertos de dev y qa
    ├── main.tf             # imagenes + modulo por ambiente
    ├── outputs.tf
    └── modules
        └── ambiente        # red, volumen y contenedores web/api/bd
```

## Requisitos

- [Git](https://git-scm.com/downloads)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (o Docker Engine en Linux) **corriendo**
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5

Verificar:

```bash
git --version
docker --version
terraform -version
```

## Pasos

### 1. Clonar el proyecto

```bash
git clone <URL_DEL_REPO>
cd <nombre-del-repo>
```

### 2. Entrar a la carpeta de terraform

```bash
cd iac
```

### 3. (Solo Windows) configurar el socket de Docker

En `terraform.tfvars` descomentar la línea:

```hcl
docker_host = "npipe:////.//pipe//docker_engine"
```

En Mac y Linux no hay que cambiar nada.

### 4. Inicializar Terraform

Descarga el provider de Docker:

```bash
terraform init
```

### 5. Revisar el plan

```bash
terraform plan
```

### 6. Aplicar

```bash
terraform apply
```

Escribir `yes` cuando lo pida. Al terminar se muestran las URLs de cada ambiente.

### 7. Verificar

```bash
docker ps
```

Deben aparecer los 6 contenedores: `web-dev`, `api-dev`, `bd-dev`, `web-qa`, `api-qa`, `bd-qa`.

Abrir en el navegador:

- DEV: http://localhost:4001
- QA: http://localhost:5001

La página muestra la respuesta del backend y la hora que devuelve postgres.

> La primera vez el backend tarda unos segundos en responder porque instala la dependencia `pg` al iniciar.

También se puede probar la API directamente:

```bash
curl http://localhost:4002/
curl http://localhost:4002/db
curl http://localhost:5002/db
```

Conexión a la base de datos (por ejemplo con DBeaver o psql):

| Ambiente | Host      | Puerto | Usuario  | Password | BD    |
|----------|-----------|--------|----------|----------|-------|
| DEV      | localhost | 4003   | postgres | postgres | appdb |
| QA       | localhost | 5003   | postgres | postgres | appdb |

### 8. Destruir todo

```bash
terraform destroy
```

## Variables

Se pueden cambiar en `terraform.tfvars`:

| Variable      | Default                       | Descripción                    |
|---------------|-------------------------------|--------------------------------|
| `docker_host` | `unix:///var/run/docker.sock` | socket del daemon de docker    |
| `imagen_web`  | `nginx:alpine`                | imagen del frontend            |
| `imagen_api`  | `node:20-alpine`              | imagen del backend             |
| `imagen_bd`   | `postgres:16-alpine`          | imagen de la base de datos     |
| `db_user`     | `postgres`                    | usuario de postgres            |
| `db_password` | `postgres`                    | password de postgres           |
| `db_name`     | `appdb`                       | nombre de la base              |
| `ambientes`   | dev / qa                      | puertos externos por ambiente  |

## Commits

El repositorio usa [Conventional Commits](https://www.conventionalcommits.org/es/v1.0.0/), por ejemplo:

```
feat(iac): crear modulo ambiente con contenedores web, api y bd
docs: agregar README con instrucciones
```
