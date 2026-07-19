#!/bin/sh
set -e

ROLE="${CONTAINER_ROLE:-php}"

if [ ! "$(ls -A /var/www/storage)" ]; then
  echo "Initializing storage directory..."
  cp -R /var/www/storage-init/. /var/www/storage
  chown -R circleit:circleit /var/www/storage
fi

rm -rf /var/www/storage-init

case "$ROLE" in
    php)
        echo "starting php bootstrap..."
        php artisan migrate --force

        php artisan optimize:clear
        ;;
    scheduler)
        echo "starting scheduler bootstrap..."
        ;;
    worker)
        echo "starting worker bootstrap..."
        ;;
    *)
        echo "unknown container role: $ROLE"
        exit 1
        ;;
esac

exec "$@"