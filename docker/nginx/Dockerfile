# ============================================
# Dockerfile - Nginx Web Solutions
# ============================================
# Imagem leve baseada em Alpine Linux
# Porta interna: 80
# ============================================

FROM nginx:1.25-alpine

# Metadados da imagem
LABEL maintainer="Web Solutions Ltda."
LABEL description="Nginx otimizado para Web Solutions"
LABEL version="1.0"

# Remove configuração padrão
RUN rm /etc/nginx/conf.d/default.conf

# Cria diretórios necessários com permissões corretas
RUN mkdir -p /var/cache/nginx/client_temp /var/run && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    chown -R nginx:nginx /var/run

# Copia configuração customizada
COPY nginx.conf /etc/nginx/nginx.conf

# Copia conteúdo estático padrão
COPY --chown=nginx:nginx index.html /usr/share/nginx/html/

# Copia script de health check
COPY healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/healthcheck.sh

# Não roda como root
USER nginx

# Porta de exposição
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["healthcheck.sh"]

# Comando de inicialização
CMD ["nginx", "-g", "daemon off;"]
