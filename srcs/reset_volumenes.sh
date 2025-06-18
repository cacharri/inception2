#!/bin/bash

echo "[reset_volumenes] Parando servicios y eliminando volúmenes antiguos..."
docker compose down -v

echo "[reset_volumenes] Borrando volumen srcs_wp_files si existe..."
docker volume rm srcs_wp_files 2>/dev/null

echo "[reset_volumenes] Reconstruyendo contenedores desde cero..."
docker compose up --build
