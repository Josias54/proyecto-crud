# 🚀 Guía para Desplegar en Render

Esta guía te ayudará a desplegar tu proyecto CRUD en la plataforma Render.

## 📋 Opciones de Despliegue

Render ofrece dos formas principales de desplegar:

### Opción 1: Despliegue Simple (Recomendado) - Solo API + PostgreSQL
Despliega la API directamente sin Nginx. Render maneja el balanceador de carga automáticamente.

### Opción 2: Despliegue con Docker Compose
Despliega todos los servicios usando Docker (API + Nginx + PostgreSQL).

---

## 🎯 Opción 1: Despliegue Simple (Recomendado)

### Paso 1: Preparar el Repositorio

1. **Sube tu código a GitHub/GitLab/Bitbucket**
   ```bash
   git init
   git add .
   git commit -m "Preparado para Render"
   git remote add origin <URL_DE_TU_REPO>
   git push -u origin main
   ```

### Paso 2: Crear Base de Datos PostgreSQL en Render

1. Ve a [Render Dashboard](https://dashboard.render.com/)
2. Click en **"New +"** → **"PostgreSQL"**
3. Configura:
   - **Name**: `crud-db` (o el nombre que prefieras)
   - **Database**: `crud_db`
   - **User**: `postgres` (o el que prefieras)
   - **Region**: Elige la más cercana a ti
   - **PostgreSQL Version**: 15 (o la más reciente)
   - **Plan**: Free tier está bien para empezar
4. Click en **"Create Database"**
5. **IMPORTANTE**: Copia las credenciales de conexión:
   - **Internal Database URL**: `postgresql://user:password@host:port/database`
   - O las variables individuales: `DB_HOST`, `DB_PORT`, `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD`

### Paso 3: Crear Servicio Web para la API

1. En Render Dashboard, click en **"New +"** → **"Web Service"**
2. Conecta tu repositorio (GitHub/GitLab/Bitbucket)
3. Selecciona el repositorio y branch
4. Configura el servicio:
   - **Name**: `api-crud` (o el nombre que prefieras)
   - **Region**: La misma que la base de datos
   - **Branch**: `main` (o tu branch principal)
   - **Root Directory**: `proyecto-crud/api-service`
   - **Environment**: `Node`
   - **Build Command**: `npm install`
   - **Start Command**: `node server.js`
5. En la sección **"Environment Variables"**, agrega:
   ```
   PORT=10000
   DB_HOST=<el_host_de_postgresql>
   DB_PORT=5432
   POSTGRES_DB=crud_db
   POSTGRES_USER=<tu_usuario>
   POSTGRES_PASSWORD=<tu_password>
   ```
   ⚠️ **Nota**: Render asigna automáticamente el puerto, pero tu código debe usar `process.env.PORT`
6. Click en **"Create Web Service"**

### Paso 4: Verificar el Despliegue

1. Espera a que el build termine (puede tomar 2-5 minutos)
2. Render te dará una URL como: `https://api-crud.onrender.com`
3. Prueba los endpoints:
   - `https://api-crud.onrender.com/api/health`
   - `https://api-crud.onrender.com/api/users`

---

## 🐳 Opción 2: Despliegue con Docker

Si prefieres desplegar todo con Docker (incluyendo Nginx):

### Paso 1: Crear Base de Datos PostgreSQL
(Sigue los mismos pasos de la Opción 1, Paso 2)

### Paso 2: Crear Servicio Web con Docker

1. En Render Dashboard, click en **"New +"** → **"Web Service"**
2. Conecta tu repositorio
3. Configura:
   - **Name**: `crud-app`
   - **Root Directory**: `proyecto-crud`
   - **Environment**: `Docker`
   - **Dockerfile Path**: `proyecto-crud/Dockerfile` (necesitarás crear uno)
4. Agrega las variables de entorno de PostgreSQL
5. Click en **"Create Web Service"**

**Nota**: Para esta opción necesitarías crear un `Dockerfile` principal que orqueste los servicios, o desplegar cada servicio por separado.

---

## 🔧 Configuración de Variables de Entorno

En Render, las variables de entorno se configuran en:
**Settings** → **Environment** → **Add Environment Variable**

Variables necesarias:
```
PORT=10000
DB_HOST=<host_de_render>
DB_PORT=5432
POSTGRES_DB=crud_db
POSTGRES_USER=<usuario>
POSTGRES_PASSWORD=<password>
```

**Importante**: Render proporciona una URL interna para la base de datos. Puedes usar:
- La URL completa: `DATABASE_URL=postgresql://user:pass@host:port/db`
- O las variables individuales como arriba

---

## 📝 Notas Importantes

1. **Puerto**: Render asigna el puerto automáticamente. Tu código ya usa `process.env.PORT || 3000`, lo cual está bien.

2. **Base de Datos**: 
   - En Render, el host de PostgreSQL será algo como `dpg-xxxxx-a.oregon-postgres.render.com`
   - No uses `localhost` o `postgres-db` como host

3. **Tiempo de Inicio**: 
   - El servicio gratuito de Render "duerme" después de 15 minutos de inactividad
   - La primera petición después de dormir puede tardar 30-60 segundos

4. **Logs**: 
   - Puedes ver los logs en tiempo real en el Dashboard de Render
   - Útiles para debuggear problemas de conexión

5. **Health Check**: 
   - Render verifica automáticamente que tu servicio responda
   - El endpoint `/api/health` es perfecto para esto

---

## 🐛 Solución de Problemas

### Error: "Cannot connect to database"
- Verifica que las variables de entorno estén correctas
- Asegúrate de usar el **host interno** de Render, no `localhost`
- Verifica que la base de datos esté en la misma región

### Error: "Port already in use"
- Render asigna el puerto automáticamente
- Asegúrate de usar `process.env.PORT` en tu código (ya lo tienes)

### El servicio se queda "dormido"
- Esto es normal en el plan gratuito
- La primera petición después de dormir puede tardar
- Considera usar un servicio de "ping" periódico para mantenerlo activo

---

## ✅ Checklist de Despliegue

- [ ] Código subido a GitHub/GitLab/Bitbucket
- [ ] Base de datos PostgreSQL creada en Render
- [ ] Variables de entorno configuradas correctamente
- [ ] Servicio Web creado y conectado al repositorio
- [ ] Build completado sin errores
- [ ] Endpoint `/api/health` responde correctamente
- [ ] Endpoints CRUD funcionando

---

## 🔗 Recursos Útiles

- [Documentación de Render](https://render.com/docs)
- [Guía de PostgreSQL en Render](https://render.com/docs/databases)
- [Variables de Entorno en Render](https://render.com/docs/environment-variables)

---

¡Buena suerte con tu despliegue! 🚀

