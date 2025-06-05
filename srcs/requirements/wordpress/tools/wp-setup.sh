#!/bin/sh

# Esperar a que MariaDB esté disponible
echo "Esperando a MariaDB..."
until mysqladmin ping -h mariadb --silent; do
  echo "MariaDB aún no está lista, esperando..."
  sleep 2
done
echo "MariaDB disponible."

# Solo instalar si no existe wp-config.php
if [ ! -f /var/www/html/wp-config.php ]; then
  cd /var/www/html || exit 1

  echo "Descargando WordPress..."
  wp core download --allow-root

  echo "Creando archivo de configuración..."
  wp config create \
    --dbname=$MYSQL_DATABASE \
    --dbuser=$MYSQL_USER \
    --dbpass=$MYSQL_PASSWORD \
    --dbhost=mariadb \
    --allow-root

  echo "Instalando WordPress..."
  wp core install \
    --url=https://$DOMAIN_NAME \
    --title="Inception" \
    --admin_user=$WP_ADMIN_USER \
    --admin_password=$WP_ADMIN_PASS \
    --admin_email=$WP_ADMIN_EMAIL \
    --skip-email \
    --allow-root
else
  echo "WordPress ya está instalado. Saltando setup."
fi

# Lanza PHP-FPM
php-fpm7.4 -F
