FROM php:8.4.19-fpm-alpine AS builder

RUN apk add --no-cache bash curl git unzip icu-dev libzip-dev oniguruma-dev

WORKDIR /var/www

RUN curl -sS https://getcomposer.org/installer | php -- --version=2.8.5 --install-dir=/usr/local/bin --filename=composer

COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress --prefer-dist --no-scripts

RUN curl -fsSL https://bun.sh/install | bash -s "bun-v1.3.9"
ENV PATH="/root/.bun/bin:$PATH"

COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

COPY ./ ./

RUN composer run-script post-autoload-dump
RUN bun run build:ssr

FROM php:8.4.19-fpm-alpine

RUN addgroup -S circleit && adduser -S -u 1001 -G circleit circleit

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS icu-dev libzip-dev postgresql-dev oniguruma-dev \
    && apk add --no-cache icu libzip postgresql-libs libpq fcgi procps curl \
    && docker-php-ext-install pdo_pgsql intl zip bcmath \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps

RUN curl -o /usr/local/bin/php-fpm-healthcheck https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck \
    && chmod +x /usr/local/bin/php-fpm-healthcheck

COPY ./docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=builder /usr/local/bin/docker-php-ext-* /usr/local/bin/

COPY ./ /var/www
COPY --from=builder /var/www/vendor /var/www/vendor
COPY --from=builder /var/www/public/build /var/www/public/build

COPY --chown=circleit:circleit ./storage /var/www/storage-init

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY ./docker/php/conf.d/*.conf /usr/local/etc/php-fpm.d/

WORKDIR /var/www

RUN chown -R circleit:circleit /var/www

USER circleit

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]