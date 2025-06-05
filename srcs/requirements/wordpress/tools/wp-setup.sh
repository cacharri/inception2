#!/bin/sh

# Esperar a que mariadb esté disponible
until mysqladmin ping -h mariadb --silent; do
    echo "Waiting for mariadb..."
    sleep 2
done

# Instalar WordPress si aún no está instalado
if [ ! -f /var/www/html/wp-config.php ]; then
    cd /var/www/html
    wp core download --allow-root

    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb \
        --path='/var/www/html' \
        --allow-root

    wp core install \
        --url=https://${DOMAIN_NAME} \
        --title="My Inception Site" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASS} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --skip-email \
        --allow-root
fi

# Ejecutar php-fpm en foreground
php-fpm7.4 -F
