#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-progress --no-interaction
fi

if [ ! -f ".env" ]; then
    echo "Creating env file for env $APP_ENV"
    cp .env.example .env
    php artisan key:generate
else
    echo "env file exists."
fi

php artisan config:clear
php artisan migrate --force --seed
php artisan clear-compiled
php artisan auth:clear-resets
php artisan optimize:clear
php artisan config:cache
composer dump-autoload


php-fpm -D
nginx -g "daemon off;"