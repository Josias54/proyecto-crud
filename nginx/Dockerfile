
FROM nginx:alpine


LABEL maintainer="nginx-gateway"
LABEL description="Nginx reverse proxy and API gateway"
LABEL version="1.0.0"


ENV NGINX_HOST=localhost
ENV NGINX_PORT=80


RUN apk add --no-cache gettext


RUN rm -rf /etc/nginx/conf.d/default.conf


RUN mkdir -p /etc/nginx/templates


COPY nginx.conf /etc/nginx/templates/default.conf.template


COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh


COPY index.html /usr/share/nginx/html/index.html


RUN mkdir -p /var/cache/nginx /var/log/nginx /var/run && \
    chown -R nginx:nginx /var/cache/nginx /var/log/nginx /var/run && \
    chmod -R 755 /var/cache/nginx /var/log/nginx /var/run

RUN apk add --no-cache curl


EXPOSE 80


HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:80/api/users || exit 1


ENTRYPOINT ["/docker-entrypoint.sh"]
