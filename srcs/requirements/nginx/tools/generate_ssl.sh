#!/bin/sh

CERT_DIR="/etc/nginx/certs"
mkdir -p "$CERT_DIR"

cat > "$CERT_DIR/openssl.cnf" <<EOF
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
C=ES
ST=Madrid
L=Madrid
O=42
OU=Student
CN=localhost

[v3_req]
subjectAltName=@alt_names

[alt_names]
DNS.1=localhost
DNS.2=ialvarez.42.fr
EOF

openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout "$CERT_DIR/server.key" \
  -out "$CERT_DIR/server.crt" \
  -config "$CERT_DIR/openssl.cnf" \
  -extensions v3_req

chmod 644 "$CERT_DIR/server.crt" "$CERT_DIR/server.key"
echo "✅ Certificado generado con SAN para localhost y ialvarez.42.fr"
