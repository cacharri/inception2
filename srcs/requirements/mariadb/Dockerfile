FROM debian:bullseye

# Instalar MariaDB
RUN apt update && apt install -y mariadb-server

# Crear carpetas de trabajo
RUN mkdir -p /conf /tools

# Copiar scripts y SQL
COPY conf/init.sql /conf/init.sql
COPY tools/init.sh /tools/init.sh

# Hacer el script ejecutable
RUN chmod +x /tools/init.sh

# Definir entrypoint
ENTRYPOINT ["/tools/init.sh"]
