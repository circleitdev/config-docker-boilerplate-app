#!/bin/sh
set -e

if [ ! "$(ls -A /var/www/storage)" ]; then
  echo "Initializing storage directory..."
  cp -R /var/www/storage-init/. /var/www/storage
  chown -R circleit:circleit /var/www/storage
fi

rm -rf /var/www/storage-init

php artisan migrate --force

php artisan optimize:clear

exec "$@"