FROM php:8.0-fpm-alpine

# Install system tools, Nginx, and Supervisor
RUN apk add --no-cache nginx supervisor bash git curl

# Install PHP extensions required by Laravel
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions pdo_mysql mbstring exif pcntl bcmath gd zip opcache

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy application source code
COPY . /var/www

# Install production dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Setup Nginx configuration
COPY Infrastructure/docker/nginx.conf /etc/nginx/http.d/default.conf

# Setup Supervisor configuration
COPY Infrastructure/docker/supervisord.conf /etc/supervisord.conf

# Setup Entrypoint script
COPY Infrastructure/docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set directory permissions for web user
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
