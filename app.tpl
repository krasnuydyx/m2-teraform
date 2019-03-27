#!/usr/bin/env bash

# Make sure every command send output. Also make sure, that the program exits after an error.
set -x

# To get the whole user_data output, we save it to a log file under /var/log/user_data.log
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo -E yum -y -q update && sudo amazon-linux-extras install -y nginx1.12 php7.2 epel
sudo -E yum install -y -q git postfix amazon-efs-utils

sudo -E yum -y -q install php php-bcmath php-cli php-common php-gd php-intl php-json php-mbstring php-mysqlnd php-pdo php-pear php-process php-soap php-xml php-pecl-zip php-pecl-mcrypt

cat << EOF > /tmp/tmp_php.ini
max_execution_time = 600
memory_limit = 768M
error_reporting = On
display_errors = Off
log_errors = On
post_max_size = 16M
upload_max_filesize = 16M
EOF

cat /tmp/tmp_php.ini | sudo -E tee --append /etc/php.ini

sudo -E git clone ${GIT_REPOSITORY_URL} /var/www/html

cat << EOF > /tmp/tmp_nginx.conf
server {
	listen 80;
	server_name _;
	set \$MAGE_ROOT /var/www/html;
	include /etc/nginx/conf.d/nginx.conf.sample;
}
EOF
sudo -E cp /tmp/tmp_nginx.conf /etc/nginx/conf.d/default.conf
sudo -E cp /var/www/html/nginx.conf.sample /etc/nginx/conf.d/
sudo -E sed -i'' "s/fastcgi_backend/php-fpm/g" /etc/nginx/conf.d/nginx.conf.sample
sudo -E sed -i'' '/server/,$d' /etc/nginx/nginx.conf
echo "}" | sudo tee --append /etc/nginx/nginx.conf

sudo -E systemctl enable php-fpm
sudo -E systemctl enable nginx
sudo -E systemctl enable postfix
sudo -E systemctl restart php-fpm
sudo -E systemctl restart nginx
sudo -E systemctl restart postfix

sudo -E mkdir -p /var/www/cache/composer
export COMPOSER_HOME=/var/www/cache/composer/
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo -E php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo -E mv composer.phar /usr/local/bin/composer

cd /var/www/html
sudo -E /usr/local/bin/composer --no-dev --optimize-autoloader --no-interaction install

sudo -E php bin/magento setup:install -n -v --db-host="${MAGENTO_DATABASE_HOST}" --db-name="${MAGENTO_DATABASE_NAME}" --db-user="${MAGENTO_DATABASE_USER}" --db-password="${MAGENTO_DATABASE_PASSWORD}" --base-url="${MAGENTO_BASE_URL}" --backend-frontname="${MAGENTO_ADMIN_FRONTNAME}" --admin-user="${MAGENTO_ADMIN_USER}" --admin-password="${MAGENTO_ADMIN_PASSWORD}" --admin-email="${MAGENTO_ADMIN_EMAIL}" --admin-firstname="${MAGENTO_ADMIN_FIRSTNAME}" --admin-lastname="${MAGENTO_ADMIN_LASTNAME}" --language="${MAGENTO_LOCALE}" --timezone="${MAGENTO_ADMIN_TIMEZONE}" --session-save=redis --session-save-redis-host=${MAGENTO_REDIS_HOST_NAME} --session-save-redis-log-level=3 --session-save-redis-db=2 --page-cache=redis --page-cache-redis-server=${MAGENTO_REDIS_HOST_NAME} --page-cache-redis-db=1 --cache-backend=redis --cache-backend-redis-server=${MAGENTO_REDIS_HOST_NAME} --cache-backend-redis-db=0

sudo -E php bin/magento config:set web/unsecure/base_url ${MAGENTO_BASE_URL}
sudo -E php bin/magento config:set web/cookie/cookie_domain ${MAGENTO_HOST_NAME}
sudo -E php bin/magento config:set admin/security/session_lifetime 1800

sudo -E php bin/magento setup:upgrade

sudo -E php bin/magento deploy:mode:set production

sudo -E php bin/magento setup:di:compile

sudo -E php bin/magento setup:static-content:deploy

sudo -E php bin/magento cron:install

sudo -E chown -R apache:apache .