#!/bin/sh
set -e

echo "[init.sh] Preparando socket de MariaDB..."
# Ya lo creamos en el Dockerfile, pero reforzamos permisos
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

echo "[init.sh] Iniciando MariaDB y ejecutando SQL de inicialización..."
# Arranca mysqld con el init-file para ejecutar tu SQL
exec mysqld --user=mysql --init-file=/conf/init.sql
