#!/bin/sh

# Esperar a que MariaDB esté disponible
until mysqladmin ping -h mariadb --silent; do
    echo "Esperando a que MariaDB esté disponible..."
    sleep 2
done

# Descargar WordPress si no está
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Descargando WordPress..."
    wp core download --path=/var/www/html --allow-root

    echo "Creando archivo de configuración..."
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb \
        --path=/var/www/html \
        --allow-root

    echo "Instalando WordPress..."
    wp core install \
        --url=https://$DOMAIN_NAME \
        --title="Inception Site" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASS \
        --admin_email=$WP_ADMIN_EMAIL \
        --path=/var/www/html \
        --skip-email \
        --allow-root

    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
fi

# Iniciar PHP-FPM
php-fpm7.4 -F
