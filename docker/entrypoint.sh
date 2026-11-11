#!/bin/sh
set -e

# If a custom command is provided (e.g. phpunit, sh, php artisan), execute it directly
if [ "$#" -gt 0 ]; then
    exec "$@"
fi

# Ensure Laravel storage directories exist with proper permissions
mkdir -p /var/www/storage/framework/cache/data
mkdir -p /var/www/storage/framework/sessions
mkdir -p /var/www/storage/framework/views
mkdir -p /var/www/storage/logs
touch /var/www/storage/logs/laravel.log
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
chmod -R 777 /var/www/storage /var/www/bootstrap/cache

# Create storage symlink if not present
php artisan storage:link || true

# Clear cached configuration to ensure environment variables are read
php artisan config:clear || true

# Re-verify permissions for web server (www-data)
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
chmod -R 777 /var/www/storage /var/www/bootstrap/cache

echo "Starting Nginx and PHP-FPM via Supervisor..."
exec /usr/bin/supervisord -c /etc/supervisord.conf

