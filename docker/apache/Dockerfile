# ============================================
# Dockerfile - Apache HTTPD Web Solutions
# ============================================
# Imagem leve baseada em Alpine Linux
# Porta interna: 80
# ============================================

FROM httpd:2.4-alpine

# Metadados da imagem
LABEL maintainer="Web Solutions Ltda."
LABEL description="Apache HTTPD otimizado para Web Solutions"
LABEL version="1.0"

# Remove configuração padrão
RUN rm /usr/local/apache2/htdocs/index.html

# Cria diretório de logs com permissões corretas
RUN mkdir -p /usr/local/apache2/logs && \
    chown -R daemon:daemon /usr/local/apache2/logs && \
    chown -R daemon:daemon /usr/local/apache2/htdocs

# Copia configuração customizada
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

# Copia conteúdo estático padrão
COPY --chown=daemon:daemon index.html /usr/local/apache2/htdocs/

# Copia script de health check
COPY healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/healthcheck.sh

# Não roda como root
USER daemon

# Porta de exposição
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["healthcheck.sh"]

# Comando de inicialização
CMD ["httpd-foreground"]
