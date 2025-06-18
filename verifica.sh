#!/bin/bash

echo "[verifica.sh] Comprobando archivo default.conf dentro de NGINX..."
docker exec -it nginx grep 'try_files' /etc/nginx/conf.d/default.conf

echo "[verifica.sh] Comprobando permisos de wp-config.php..."
docker exec -it wordpress ls -l /var/www/html/wp-config.php

echo "[verifica.sh] Listando recursos estáticos de WordPress..."
docker exec -it wordpress ls -l /var/www/html/wp-content/themes/*/style.css

echo "[verifica.sh] Si todo está OK, los estilos deberían funcionar correctamente."
