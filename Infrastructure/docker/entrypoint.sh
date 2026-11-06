#!/bin/sh
set -e

# Ensure Laravel storage directories exist with proper permissions
mkdir -p /var/www/storage/framework/cache/data
mkdir -p /var/www/storage/framework/sessions
mkdir -p /var/www/storage/framework/views
mkdir -p /var/www/storage/logs
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Clear cached configuration to ensure environment variables are read
php artisan config:clear || true

echo "Starting Nginx and PHP-FPM via Supervisor..."
exec /usr/bin/supervisord -c /etc/supervisord.conf
