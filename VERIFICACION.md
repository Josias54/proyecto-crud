# ✅ Verificación de Servicios CRUD

## 🧪 Cómo verificar que todos los servicios funcionan

### 1. Verificar que los contenedores están corriendo

```bash
docker-compose ps
```

**Resultado esperado:** Los 3 servicios deben estar en estado "Up" y "healthy":
- ✅ `proyecto-crud-nginx-gateway-1` - Up (healthy)
- ✅ `proyecto-crud-api-service-1` - Up (healthy)  
- ✅ `proyecto-crud-postgres-db-1` - Up (healthy)

---

### 2. Verificar PostgreSQL Database

```bash
docker-compose exec postgres-db psql -U postgres -d crud_db -c "SELECT COUNT(*) FROM users;"
```

**Resultado esperado:** Debe mostrar el número de usuarios (ej: `1`)

**Verificar la estructura de la tabla:**
```bash
docker-compose exec postgres-db psql -U postgres -d crud_db -c "\d users"
```

**Resultado esperado:** Debe mostrar la tabla con columnas: `id`, `nombre`, `correo`

---

### 3. Verificar API Service

**Desde PowerShell:**
```powershell
Invoke-WebRequest -Uri http://localhost/api/users -UseBasicParsing
```

**Desde el navegador:**
```
http://localhost/api/users
```

**Resultado esperado:** Debe mostrar un JSON con los usuarios (ej: `[{"id":1,"nombre":"Juan","correo":"juan@mail.com"}]`)

**Verificar health endpoint:**
```
http://localhost/api/health
```

**Resultado esperado:** Debe mostrar estado "ok" y información de la base de datos

---

### 4. Verificar NGINX Gateway

**Desde el navegador:**
```
http://localhost
```

**Resultado esperado:** Debe mostrar la interfaz web del CRUD con:
- Formularios para GET, POST, PUT, DELETE
- Indicador de conexión a PostgreSQL
- Lista de usuarios

---

## 🔍 Solución de Problemas

### Si los contenedores no están corriendo:

```bash
# Detener todos
docker-compose down

# Reiniciar todos
docker-compose up -d --build

# Ver logs de errores
docker-compose logs
```

### Si PostgreSQL no responde:

```bash
# Ver logs de PostgreSQL
docker-compose logs postgres-db

# Reiniciar PostgreSQL
docker-compose restart postgres-db
```

### Si API Service no responde:

```bash
# Ver logs del API
docker-compose logs api-service

# Verificar que puede conectarse a PostgreSQL desde el contenedor
docker-compose exec api-service curl http://localhost:3000/api/users
```

### Si NGINX no responde:

```bash
# Ver logs de NGINX
docker-compose logs nginx-gateway

# Verificar configuración
docker-compose exec nginx-gateway nginx -t

# Reiniciar NGINX
docker-compose restart nginx-gateway
```

---

## ✅ Checklist de Verificación

- [ ] Los 3 contenedores están corriendo (docker-compose ps)
- [ ] PostgreSQL tiene la tabla `users` creada
- [ ] API responde en `http://localhost/api/users`
- [ ] Health endpoint responde en `http://localhost/api/health`
- [ ] Interfaz web carga en `http://localhost`
- [ ] Puedo crear usuarios (POST)
- [ ] Puedo listar usuarios (GET)
- [ ] Puedo actualizar usuarios (PUT)
- [ ] Puedo eliminar usuarios (DELETE)

---

## 📝 Notas

- Todos los servicios deben estar en la misma red de Docker (automático con docker-compose)
- El puerto 80 debe estar disponible en tu sistema
- Si usas WSL, asegúrate de que Docker Desktop esté corriendo

