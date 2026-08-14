#!/bin/sh
set -e

DOMAIN_NAME=${DOMAIN_NAME:-localhost}

secure_wordpress_files() {
  # PHP-FPM must not be able to modify executable WordPress code or config.
  chown -R root:root /var/www/html
  find /var/www/html -type d -exec chmod 755 {} +
  find /var/www/html -type f -exec chmod 644 {} +

  if [ -f /var/www/html/wp-config.php ]; then
    chown root:www-data /var/www/html/wp-config.php
    chmod 640 /var/www/html/wp-config.php
  fi

  # WordPress only needs runtime write access for user uploads.
  mkdir -p /var/www/html/wp-content/uploads
  chown -R www-data:www-data /var/www/html/wp-content/uploads
}

disable_dashboard_code_changes() {
  if [ -f /var/www/html/wp-config.php ]; then
    wp config set DISALLOW_FILE_EDIT true --raw --path=/var/www/html --allow-root
    wp config set DISALLOW_FILE_MODS true --raw --path=/var/www/html --allow-root
  fi
}

# Si ya está instalado, no repetir
if [ -f /var/www/html/.installed ]; then
  echo "[wp-setup] WordPress ya está instalado. Saltando setup."
  disable_dashboard_code_changes
  secure_wordpress_files
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
secure_wordpress_files

echo "[wp-setup] Creando wp-config.php..."
wp config create \
  --dbname=${MYSQL_DATABASE} \
  --dbuser=${MYSQL_USER} \
  --dbpass=${MYSQL_PASSWORD} \
  --dbhost=mariadb \
  --path=/var/www/html \
  --allow-root

echo "[wp-setup] Instalando WordPress con dominio: ${DOMAIN_NAME}..."
wp core install \
  --url=https://${DOMAIN_NAME} \
  --title="Inception" \
  --admin_user=${WP_ADMIN_USER} \
  --admin_password=${WP_ADMIN_PASS} \
  --admin_email=${WP_ADMIN_EMAIL} \
  --path=/var/www/html \
  --allow-root

echo "[wp-setup] Instalando y activando tema 'twentytwenty'..."
wp theme install twentytwenty --activate --path=/var/www/html --allow-root

# Marcar como instalado
touch /var/www/html/.installed
disable_dashboard_code_changes
secure_wordpress_files

echo "[wp-setup] WordPress instalado correctamente. Arrancando PHP-FPM..."

# Configurar php-fpm
sed -i 's|listen = /run/php/7.4-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf
sed -i 's/;clear_env = no/clear_env = no/' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php

exec php-fpm7.4 -F
