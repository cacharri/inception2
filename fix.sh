#!/bin/bash

echo "[fix.sh] Limpiando volúmenes y contenedores..."
docker compose -f srcs/docker-compose.yml down --volumes --remove-orphans

echo "[fix.sh] Aplicando patch a default.conf..."
patch srcs/requirements/nginx/conf/default.conf <<'EOF'
diff --git a/srcs/requirements/nginx/conf/default.conf b/srcs/requirements/nginx/conf/default.conf
index 1111111..2222222 100644
--- a/srcs/requirements/nginx/conf/default.conf
+++ b/srcs/requirements/nginx/conf/default.conf
@@ -8,8 +8,11 @@ server {
     root /var/www/html;
     index index.php index.html;

-    location / {
-        try_files $uri $uri/ =404;
-    }
+    location / {
+        try_files $uri $uri/ /index.php$is_args$args;
+    }

     location ~ \.php$ {
-        include snippets/fastcgi-php.conf;
+        include fastcgi_params;
+        fastcgi_index index.php;
         fastcgi_pass wordpress:9000;
         fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
-        include fastcgi_params;
     }
+
+    location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg|woff|woff2|ttf|eot)$ {
+        access_log off;
+        log_not_found off;
+        expires max;
+    }
 }
EOF

echo "[fix.sh] Reconstruyendo e iniciando servicios..."
docker compose -f srcs/docker-compose.yml up --build -d

echo "[fix.sh] ¡Listo! Accede a https://localhost o https://ialvarez.42.fr"
