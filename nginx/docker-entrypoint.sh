#!/bin/sh
set -e

# Reemplazar variables de entorno en nginx.conf
envsubst '${API_SERVICE_URL}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

# Iniciar nginx
exec nginx -g 'daemon off;'

