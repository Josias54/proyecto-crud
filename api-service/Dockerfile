# ============================================
# Dockerfile para api-service
# Node.js + Express API Service
# ============================================

# Usar imagen base de Node.js
FROM node:18-alpine

# Metadata del contenedor
LABEL maintainer="api-service"
LABEL description="API REST service with Node.js and Express"
LABEL version="1.0.0"

# Variables de entorno
ENV NODE_ENV=production
ENV PORT=3000

# Crear directorio de trabajo
WORKDIR /app

# Instalar herramientas necesarias y crear usuario no-root
RUN apk add --no-cache curl && \
    addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Copiar archivos de dependencias primero (optimización de cache)
COPY package*.json ./

# Instalar dependencias de producción
RUN npm install --production && \
    npm cache clean --force

# Cambiar propietario de node_modules antes de copiar código
RUN chown -R nodejs:nodejs /app

# Copiar el resto del código fuente
COPY --chown=nodejs:nodejs . .

# Cambiar a usuario no-root
USER nodejs

# Exponer puerto de la aplicación
EXPOSE 3000

# Healthcheck para verificar que el servicio esté funcionando
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:3000/api/users || exit 1

# Comando para iniciar la aplicación
CMD ["node", "server.js"]
