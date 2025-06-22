FROM debian:bullseye

# 1) Instalar PHP-FPM, extensiones y cliente MySQL
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      php7.4-fpm php7.4-mysql \
      default-mysql-client \
      curl less unzip git procps \
      libzip-dev php-zip php-curl php-mbstring php-xml php-gd && \
    rm -rf /var/lib/apt/lists/*

# 2) Prepara dirs
RUN mkdir -p /var/www/html /run/php

WORKDIR /var/www/html

# 3) Haz que php-fpm escuche en TCP (no socket unix)
RUN sed -i 's|^;*listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

# 4) Instala WP-CLI
RUN curl -sSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
      -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

# 5) Copia el script de setup y le da permisos
COPY tools/wp-setup.sh /usr/local/bin/wp-setup.sh
COPY tools/wp-config.php /tmp/wp-config.php
RUN chmod +x /usr/local/bin/wp-setup.sh

# 6) Crea un alias para php-fpm
RUN ln -sf /usr/sbin/php-fpm7.4 /usr/local/bin/php-fpm



ENTRYPOINT [ "wp-setup.sh"]

EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.4", "-F"]