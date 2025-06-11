FROM debian:bullseye

# Instalar dependencias
RUN apt-get update && \
    apt-get install -y php php-fpm php-mysql wget curl unzip less mariadb-client \
    git procps libzip-dev php-zip php-curl php-mbstring php-xml php-gd php-cli \
    php-soap php-intl php-bcmath php-imagick && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Crear directorio HTML si no existe (no meter contenido todavía)
RUN mkdir -p /var/www/html

# Copiar script de setup
COPY tools/wp-setup.sh /usr/local/bin/wp-setup.sh
RUN chmod +x /usr/local/bin/wp-setup.sh

# Usuario de ejecución
RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

EXPOSE 9000

CMD ["/usr/local/bin/wp-setup.sh"]
