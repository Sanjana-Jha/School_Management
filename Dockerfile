FROM php:8.0-fpm-alpine

# Install system utilities, Nginx, and Supervisor
RUN apk add --no-cache nginx supervisor bash git curl ca-certificates

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

# Install PHPUnit runner for CI testing
RUN curl -sSL https://phar.phpunit.de/phpunit-9.phar -o /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit \
    && mkdir -p /var/www/vendor/bin \
    && ln -sf /usr/local/bin/phpunit /var/www/vendor/bin/phpunit

# Setup Nginx configuration
COPY docker/nginx/conf.d/app.conf /etc/nginx/http.d/default.conf
RUN sed -i 's/\r$//' /etc/nginx/http.d/default.conf

# Setup Supervisor configuration
COPY docker/supervisord.conf /etc/supervisord.conf
RUN sed -i 's/\r$//' /etc/supervisord.conf

# Setup Entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh && chmod +x /usr/local/bin/entrypoint.sh

# Ensure Laravel storage and bootstrap cache directories exist with proper permissions
RUN mkdir -p /var/www/storage/framework/cache/data \
    && mkdir -p /var/www/storage/framework/sessions \
    && mkdir -p /var/www/storage/framework/views \
    && mkdir -p /var/www/storage/app/public \
    && mkdir -p /var/www/storage/logs \
    && touch /var/www/storage/logs/laravel.log \
    && mkdir -p /var/www/bootstrap/cache \
    && chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 777 /var/www/storage /var/www/bootstrap/cache

EXPOSE 80

ENTRYPOINT ["/bin/sh", "/usr/local/bin/entrypoint.sh"]
