#!/bin/sh
set -e

# Si ya está instalado, no repetir
if [ -f /var/www/html/.installed ]; then
  echo "[wp-setup] WordPress ya está instalado. Saltando setup."
  exec php-fpm7.4 -F
fi

echo "[wp-setup] Esperando a MariaDB..."
until mysqladmin ping -h mariadb --silent; do
  sleep 2
done
echo "[wp-setup] MariaDB disponible."

echo "[wp-setup] Limpiando /var/www/html..."
rm -rf /var/www/html/*
mkdir -p /var/www/html

echo "[wp-setup] Descargando WordPress en /var/www/html..."
wp core download --allow-root --path=/var/www/html

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

chown www-data:www-data /var/www/html/wp-config.php

echo "[wp-setup] Instalando WordPress con localhost..."
wp core install \
  --url=https://localhost \
  --title="Inception" \
  --admin_user=${WP_ADMIN_USER} \
  --admin_password=${WP_ADMIN_PASS} \
  --admin_email=${WP_ADMIN_EMAIL} \
  --path=/var/www/html \
  --allow-root

# Marcar como instalado
touch /var/www/html/.installed

echo "[wp-setup] WordPress instalado correctamente. Arrancando PHP-FPM..."

# Configurar php-fpm
sed -i 's|listen = /run/php/7.4-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf
sed -i 's/;clear_env = no/clear_env = no/' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php

exec php-fpm7.4 -F
