#!/bin/sh
set -e

# Espera a que mysqld esté disponible
echo "Esperando a que MariaDB arranque..."
until mysqladmin ping -h localhost --silent; do
  sleep 1
done

# Ejecuta el SQL
echo "Ejecutando script de inicialización SQL..."
mysql -u root -p$MYSQL_ROOT_PASSWORD < /conf/init.sql
