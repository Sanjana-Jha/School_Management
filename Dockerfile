FROM php:8.0-fpm-alpine

# Install helper to install PHP extensions easily
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# Install system utilities & required PHP extensions
RUN apk add --no-cache bash git curl \
    && install-php-extensions pdo_mysql mbstring exif pcntl bcmath gd zip

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

EXPOSE 9000
CMD ["php-fpm"]
