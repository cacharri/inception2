FROM debian:bullseye

# Instalar NGINX y OpenSSL
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# Crear directorio para certificados (en caso de que no exista aún)
RUN mkdir -p /etc/nginx/certs

# Copiar config y script de generación de certificados
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY tools/generate_ssl.sh /usr/local/bin/generate_ssl.sh

# Ejecutar el script para generar el certificado SSL
RUN chmod +x /usr/local/bin/generate_ssl.sh && \
    /usr/local/bin/generate_ssl.sh

# Exponer el puerto HTTPS
EXPOSE 443

# Lanzar nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]
