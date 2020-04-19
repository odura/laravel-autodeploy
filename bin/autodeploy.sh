#!/usr/bin/env bash

# set a default value
AUTODEPLOY_MAINTENANCE=false

# read all var from .env file
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

# Turn on maintenance
if [[ "$AUTODEPLOY_MAINTENANCE"=="true" ]]
then
    php artisan down
fi

# Clear all as possible
php artisan cache:clear
php artisan route:clear
php artisan view:clear
php artisan config:clear

# Git pull
git pull

# Composer update
if [[ "$AUTODEPLOY_COMPOSER"=="true" ]]
then
    composer update
fi

# npm update
if [[ "$AUTODEPLOY_NPM"=="true" ]]
then
    npm update
fi

# php migrate
php artisan migrate --force

# npm run prod or dev
npm run $APP_ENV

# Turn on live
if [[ "$AUTODEPLOY_MAINTENANCE"=="true" ]]
then
    php artisan up
fi

# php test
php artisan test