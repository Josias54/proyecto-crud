# ============================================
# Dockerfile para nginx-gateway
# Nginx Reverse Proxy / API Gateway
# ============================================

# Usar imagen oficial de Nginx
FROM nginx:alpine

# Metadata del contenedor
LABEL maintainer="nginx-gateway"
LABEL description="Nginx reverse proxy and API gateway"
LABEL version="1.0.0"

# Variables de entorno
ENV NGINX_HOST=localhost
ENV NGINX_PORT=80

# Eliminar configuración por defecto de Nginx
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copiar configuración personalizada
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar página HTML para probar la API
COPY index.html /usr/share/nginx/html/index.html

# Crear directorios necesarios y ajustar permisos
RUN mkdir -p /var/cache/nginx /var/log/nginx /var/run && \
    chown -R nginx:nginx /var/cache/nginx /var/log/nginx /var/run && \
    chmod -R 755 /var/cache/nginx /var/log/nginx /var/run

# Instalar herramientas para healthcheck
RUN apk add --no-cache curl

# Nota: No validamos la configuración aquí porque api-service no existe durante el build
# Nginx validará automáticamente al iniciar y mostrará errores si hay problemas

# Exponer puerto 80
EXPOSE 80

# Healthcheck para verificar que Nginx esté funcionando
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:80/api/users || exit 1

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
