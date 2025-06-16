FROM debian:bullseye

RUN apt update && apt install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Hacer que MariaDB escuche en todas las interfaces
RUN sed -i "s/^bind-address\s*=.*$/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

# Crear directorios
RUN mkdir -p /conf /tools /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld

# Copiar init
COPY conf/init.sql  /conf/init.sql
COPY tools/init.sh   /tools/init.sh

RUN chmod +x /tools/init.sh

EXPOSE 3306

CMD ["sh", "/tools/init.sh"]
