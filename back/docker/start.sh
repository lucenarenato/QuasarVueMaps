#!/usr/bin/env bash

set -e

role=${CONTAINER_ROLE:-laravel.test}
env=${APP_ENV:-production}

if [ "$env" != "local" ]; then
    echo "Caching configuration..."
    (cd /var/www/html && php artisan config:cache && php artisan route:cache && php artisan view:cache)
fi

echo "Running the queue..."
php /var/www/html/artisan queue:work --verbose --tries=3 --timeout=90

while [ true ]; do
    php /var/www/html/artisan schedule:run --verbose --no-interaction &
    sleep 60
done
