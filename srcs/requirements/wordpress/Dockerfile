FROM debian:bullseye

# Instalar dependencias
RUN apt-get update && \
    apt-get install -y php php-fpm php-mysql wget curl mariadb-client unzip less \
    php-cli php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    mkdir -p /var/www/html

# Copiar archivos personalizados
COPY tools/wp-setup.sh /usr/local/bin/wp-setup.sh
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

RUN chmod +x /usr/local/bin/wp-setup.sh && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Puerto donde escucha php-fpm
EXPOSE 9000

# Usar wp-setup.sh como entrypoint
CMD ["/usr/local/bin/wp-setup.sh"]

