#!/bin/sh

CERT_DIR="/etc/nginx/certs"
DOMAIN=${DOMAIN_NAME:-"ialvarez.42.fr"}  # Usa variable o valor por defecto

mkdir -p "$CERT_DIR"

# Generar clave y certificado autofirmado
openssl req \
    -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout "$CERT_DIR/server.key" \
    -out "$CERT_DIR/server.crt" \
    -subj "/C=ES/ST=Madrid/L=Madrid/O=42/OU=Student/CN=${DOMAIN}"

echo "✅ Certificado generado en $CERT_DIR para dominio ${DOMAIN}"
