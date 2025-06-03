FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y php php-fpm php-mysql wget tar unzip && \
    mkdir -p /var/www/html && \
    wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz -C /var/www/html --strip-components=1 && \
    rm latest.tar.gz && \
    chown -R www-data:www-data /var/www/html

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 9000

CMD ["sh", "-c", "php-fpm* -F"]

