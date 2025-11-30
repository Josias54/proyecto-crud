# Proyecto CRUD - API REST con Docker

## 📋 Descripción

Este es un **CRUD completo** (Create, Read, Update, Delete) basado en una arquitectura de **3 contenedores**:

1. **NGINX / API Gateway** - Recibe las peticiones del cliente y las redirige
2. **api-service** - Servicio backend con Node.js + Express que procesa las operaciones CRUD
3. **PostgreSQL Database** - Base de datos para almacenar los datos de usuarios

## 🏗️ Arquitectura

```
Cliente (Navegador)
    ↓
NGINX / API Gateway (Puerto 8080)
    ↓
api-service (Puerto 3000)
    ↓
PostgreSQL Database (Puerto 5432)
```

## 📁 Estructura del Proyecto

```
proyecto-crud/
├── api-service/        # Servicio API con Node.js + Express
│   ├── Dockerfile
│   ├── package.json
│   └── server.js       # Endpoints CRUD
├── nginx/              # Gateway/Proxy Nginx
│   ├── Dockerfile
│   ├── nginx.conf      # Configuración del proxy
│   └── index.html      # Interfaz web del CRUD
├── docker-compose.yml  # Orquestación de 3 contenedores
└── README.md
```

## 🔧 Operaciones CRUD Implementadas

| Operación | Método HTTP | Endpoint | Descripción |
|-----------|-------------|----------|-------------|
| **C**reate | POST | `/api/users` | Crear nuevo usuario |
| **R**ead | GET | `/api/users` | Obtener todos los usuarios |
| **R**ead | GET | `/api/users/:id` | Obtener usuario por ID |
| **U**pdate | PUT | `/api/users/:id` | Actualizar usuario existente |
| **D**elete | DELETE | `/api/users/:id` | Eliminar usuario |

## Cómo iniciar el servidor

### 1. Ir al directorio del proyecto
```bash
cd proyecto-crud
```

### 2. Iniciar todos los contenedores
```bash
docker-compose up --build
```

**O en modo detached (segundo plano):**
```bash
docker-compose up --build -d
```

### 3. Ver el estado de los contenedores
```bash
docker-compose ps
```

### 4. Ver los logs
```bash
docker-compose logs -f
```

### 5. Detener los contenedores
```bash
docker-compose down
```

## Endpoints disponibles

### GET - Listar todos los usuarios
- **URL:** `http://localhost:8080/api/users`
- **Método:** GET
- **Descripción:** Obtiene todos los usuarios registrados

### GET - Obtener usuario por ID
- **URL:** `http://localhost:8080/api/users/:id`
- **Método:** GET
- **Descripción:** Obtiene un usuario específico por su ID
- **Ejemplo:** `http://localhost:8080/api/users/1`

### POST - Crear usuario
- **URL:** `http://localhost:8080/api/users`
- **Método:** POST
- **Descripción:** Crea un nuevo usuario
- **Body (JSON):**
  ```json
  {
    "nombre": "Juan",
    "correo": "juan@mail.com"
  }
  ```

### PUT - Actualizar usuario
- **URL:** `http://localhost:8080/api/users/:id`
- **Método:** PUT
- **Descripción:** Actualiza un usuario existente
- **Ejemplo:** `http://localhost:8080/api/users/1`
- **Body (JSON):**
  ```json
  {
    "nombre": "Juan Actualizado",
    "correo": "juan.actualizado@mail.com"
  }
  ```

### DELETE - Eliminar usuario
- **URL:** `http://localhost:8080/api/users/:id`
- **Método:** DELETE
- **Descripción:** Elimina un usuario por su ID
- **Ejemplo:** `http://localhost:8080/api/users/1`

## 🐳 Servicios Docker

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| **nginx-gateway** | 8080 | Recibe peticiones del cliente y actúa como API Gateway |
| **api-service** | 3000 (interno) | Procesa todas las operaciones CRUD |
| **postgres-db** | 5432 (interno) | Almacena los datos de usuarios (nombre, correo) |

## 📊 Esquema de Base de Datos

La tabla `users` tiene la siguiente estructura:

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | SERIAL PRIMARY KEY | Identificador único autoincremental |
| `nombre` | TEXT | Nombre del usuario |
| `correo` | TEXT | Correo electrónico del usuario |

## ✅ Funcionalidades

- ✅ **Crear usuarios** (POST) - Formulario web interactivo
- ✅ **Listar usuarios** (GET) - Muestra todos los usuarios en la interfaz
- ✅ **Buscar usuario** (GET por ID) - Obtener un usuario específico
- ✅ **Actualizar usuarios** (PUT) - Editar nombre y correo
- ✅ **Eliminar usuarios** (DELETE) - Eliminar con confirmación
- ✅ **Interfaz web completa** - Formularios para todas las operaciones CRUD
- ✅ **Validación de datos** - Validación en frontend y backend
- ✅ **Manejo de errores** - Mensajes claros de error y éxito
- ✅ **Indicador de conexión** - Muestra el estado de conexión a PostgreSQL

