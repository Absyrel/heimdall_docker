#!/bin/bash
# Init project dir
if [ ! -d "/home/www/heimdall_web" ]; then
    echo "-- First container startup --"
    git clone https://github.com/heimdall-watch/heimdall_web.git /home/www/heimdall_web
    mkdir -p /home/www/heimdall_web/config/jwt
    JWT_PASSPHRASE=`cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 32 | head -n 1`
    APP_SECRET=`cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 32 | head -n 1`
    cat >/home/www/heimdall_web/.env.local <<EOL
APP_SECRET=${APP_SECRET}
JWT_PASSPHRASE=${JWT_PASSPHRASE}
EOL
    openssl genrsa -out /home/www/heimdall_web/config/jwt/private.pem -aes256 -passout pass:${JWT_PASSPHRASE} 4096
    openssl rsa -pubout -in /home/www/heimdall_web/config/jwt/private.pem -out /home/www/heimdall_web/config/jwt/public.pem -passin pass:${JWT_PASSPHRASE}
    chown -R heimdall:www-data /home/www/heimdall_web
    chmod -R 770 /home/www/heimdall_web/config/jwt

    if [[ ${APP_ENV} == "dev" ]]; then
        echo "-- Dev env --"
        mv ${PHP_INI_DIR}/php.ini-development ${PHP_INI_DIR}/php.ini
        # To be able to easily modify the project files from the host
        chmod -R 777 /home/www/heimdall_web
    else
        echo "-- Prod env --"
        mv ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini
    fi

    sudo -u heimdall composer install -d /home/www/heimdall_web
    FIXTURES_GRP=${APP_ENV}Fixtures
    sudo -u heimdall /home/www/heimdall_web/bin/console doctrine:schema:update --force
    sudo -u heimdall /home/www/heimdall_web/bin/console doctrine:fixtures:load --group=${FIXTURES_GRP^}
fi

apache2-foreground