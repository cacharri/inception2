#!/bin/sh

CERT_DIR="/etc/nginx/certs"
DOMAIN="ialvarez.42.fr"

mkdir -p $CERT_DIR
openssl req \
    -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout $CERT_DIR/server.key \
    -out $CERT_DIR/server.crt \
    -subj "/C=ES/ST=Madrid/L=Madrid/O=42/OU=Student/CN=$DOMAIN"
