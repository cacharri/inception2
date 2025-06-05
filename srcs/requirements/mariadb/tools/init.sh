#!/bin/bash
service mysql start

# Esperar a que MariaDB esté activo
until mysqladmin ping --silent; do
    echo "Esperando MariaDB..."
    sleep 1
done

# Ejecutar SQL de inicialización
mysql -u root -p"$MYSQL_ROOT_PASSWORD" < /conf/init.sql

# Mantener el contenedor vivo como debe ser (PID 1)
exec mysqld
