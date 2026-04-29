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

FROM nginx:1.28.3-alpine

RUN addgroup -S circleit && adduser -S -u 1001 -G circleit circleit

COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /var/www/public /var/www/public

WORKDIR /var/www/public

RUN touch /var/run/nginx.pid \
    && chown -R circleit:circleit /var/run/nginx.pid \
    && chown -R circleit:circleit /var/cache/nginx \
    && chown -R circleit:circleit /var/www/public

USER circleit

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]