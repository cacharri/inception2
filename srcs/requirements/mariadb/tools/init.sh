#!/bin/sh

# Este script se ejecuta como entrypoint del contenedor de MariaDB.
# Copia el archivo SQL de configuración inicial a la ruta que MariaDB usará al iniciar.

# Copiar init.sql al directorio de inicialización de MariaDB
cp /conf/init.sql /docker-entrypoint-initdb.d/init.sql

# Ejecutar el entrypoint original de MariaDB
exec mysqld
