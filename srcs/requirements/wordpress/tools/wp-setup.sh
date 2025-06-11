#!/bin/sh

echo "Esperando a MariaDB..."
until mysqladmin ping -h mariadb --silent; do
  echo "MariaDB aún no está lista, esperando..."
  sleep 2
done

echo "MariaDB disponible."

if [ ! -f /var/www/html/wp-config.php ]; then
  echo "Descargando WordPress en /tmp..."
  wp core download --allow-root --path=/tmp/wordpress

  echo "Moviendo WordPress a /var/www/html..."
  cp -R /tmp/wordpress/* /var/www/html

  echo "Corrigiendo permisos..."
  chown -R www-data:www-data /var/www/html
  chmod -R 755 /var/www/html

  echo "Creando archivo de configuración..."
  wp config create \
    --dbname=${MYSQL_DATABASE} \
    --dbuser=${MYSQL_USER} \
    --dbpass=${MYSQL_PASSWORD} \
    --dbhost=mariadb \
    --path=/var/www/html \
    --allow-root

  echo "Instalando WordPress..."
  wp core install \
    --url=https://${DOMAIN_NAME} \
    --title="Inception" \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${WP_ADMIN_PASS} \
    --admin_email=${WP_ADMIN_EMAIL} \
    --path=/var/www/html \
    --allow-root
else
  echo "WordPress ya está instalado. Saltando instalación."
fi

exec php-fpm7.4 -F
