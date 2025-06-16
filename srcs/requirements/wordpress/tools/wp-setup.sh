#!/bin/sh

echo "[wp-setup] Esperando a MariaDB..."
until mysqladmin ping -h mariadb --silent; do
  sleep 2
done
echo "[wp-setup] MariaDB disponible."

if [ ! -f /var/www/html/wp-config.php ]; then
  cp /tmp/wp-config.php /var/www/html/wp-config.php

  echo "[wp-setup] Descargando WordPress en /tmp..."
  wp core download --allow-root --path=/tmp/wordpress

  echo "[wp-setup] Moviendo WordPress a /var/www/html..."
  cp -R /tmp/wordpress/* /var/www/html

  echo "[wp-setup] Corrigiendo permisos..."
  chown -R www-data:www-data /var/www/html
  chmod -R 755 /var/www/html

  echo "[wp-setup] Creando wp-config.php..."
  wp config create \
    --dbname=${MYSQL_DATABASE} \
    --dbuser=${MYSQL_USER} \
    --dbpass=${MYSQL_PASSWORD} \
    --dbhost=mariadb \
    --path=/var/www/html \
    --allow-root

  echo "[wp-setup] Instalando WordPress..."
  wp core install \
    --url=https://${DOMAIN_NAME} \
    --title="Inception" \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${WP_ADMIN_PASS} \
    --admin_email=${WP_ADMIN_EMAIL} \
    --path=/var/www/html \
    --allow-root
  echo "WordPress instalado correctamente."

else
  echo "[wp-setup] WordPress ya está instalado. Saltando."
fi

sed -i 's/listen = \/run\/php\/7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf
sed -i 's/;clear_env = no/clear_env = no/' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php

echo "[wp-setup] Arrancando PHP-FPM en TCP:9000..."
exec "$@"
