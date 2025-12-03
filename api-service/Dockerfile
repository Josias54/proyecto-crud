
FROM node:18-alpine


LABEL maintainer="api-service"
LABEL description="API REST service with Node.js and Express"
LABEL version="1.0.0"


ENV NODE_ENV=production
ENV PORT=3000


WORKDIR /app


RUN apk add --no-cache curl && \
    addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001


COPY package*.json ./


RUN npm install --production && \
    npm cache clean --force


RUN chown -R nodejs:nodejs /app


COPY --chown=nodejs:nodejs . .

USER nodejs


EXPOSE 3000


HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:3000/api/users || exit 1


CMD ["node", "server.js"]
