FROM debian:12.13 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    lsb-release \
    gnupg \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/sury-php.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/sury-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" \
    > /etc/apt/sources.list.d/sury-php.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    php8.4-cli \
    php8.4-mbstring \
    php8.4-xml \
    php8.4-curl \
    php8.4-zip \
    php8.4-opcache \
    php8.4-readline \
    php8.4-intl \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://getcomposer.org/installer | php --  --version=2.8.5 --install-dir=/usr/local/bin --filename=composer

RUN curl -fsSL https://bun.sh/install | bash -s "bun-v1.3.9"

ENV PATH="/root/.bun/bin:$PATH"

WORKDIR /var/www

COPY . /var/www

RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

RUN bun install && bun run build

FROM nginx:1.28.3-alpine

RUN addgroup -S circleit && adduser -S -u 1001 -G circleit circleit

COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf

COPY --from=builder /var/www/public /var/www/public

WORKDIR /var/www/public

RUN touch /var/run/nginx.pid \
    && chown -R circleit:circleit /var/run/nginx.pid \
    && chown -R circleit:circleit /var/cache/nginx

EXPOSE 80

USER circleit
CMD ["nginx", "-g", "daemon off;"]