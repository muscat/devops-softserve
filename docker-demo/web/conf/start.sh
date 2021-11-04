#!/bin/bash


# force TZ to avoid prompts while install
export DEBIAN_FRONTEND=noninteractive
ln -fs /usr/share/zoneinfo/Europe/Kiev /etc/localtime


# install neccecery packages (apache, php, php extras, ...)
/usr/bin/apt update
/usr/bin/apt install -y apache2 php libapache2-mod-php php-mysql wget net-tools
/usr/bin/apt install -y php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip


# slight tuning apache
echo "ServerName localhost" >> /etc/apache2/apache2.conf


# listen on ipv4 interfaces only
/usr/bin/sed -i "s/isten \([0-9]\)/isten 0.0.0.0:\1/" /etc/apache2/ports.conf


# enable mod_rewrite
/usr/sbin/a2enmod rewrite


# download and extract wordpress installation
cd /var/www/html || exit 1
/usr/bin/wget https://wordpress.org/latest.tar.gz
/usr/bin/tar zxvf latest.tar.gz && rm -f latest.tar.gz


# some wordpress tricks
touch wordpress/.htaccess
mkdir wordpress/wp-content/upgrade


# files/folders sanity
chown -R www-data:www-data wordpress
find wordpress/ -type d -exec chmod 750 {} \;
find wordpress/ -type f -exec chmod 640 {} \;


# replace hash salt
wget --output-document=salt.tmp   https://api.wordpress.org/secret-key/1.1/salt/
cat wordpress/wp-config-sample.php | grep -v 'put your unique phrase here' > wordpress/wp-config.php
cat salt.tmp >> wordpress/wp-config.php && rm -f salt.tmp


# configure connection parameters
sed -i "s/^define.*DB_NAME.*$/define('DB_NAME',         '"$WORDPRESS_DB_NAME"');/"     wordpress/wp-config.php
sed -i "s/^define.*DB_USER.*$/define('DB_USER',         '"$WORDPRESS_DB_USER"');/"     wordpress/wp-config.php
sed -i "s/^define.*DB_PASSWORD.*$/define('DB_PASSWORD', '"$WORDPRESS_DB_PASSWORD"');/" wordpress/wp-config.php
sed -i "s/^define.*DB_HOST.*$/define('DB_HOST',         '"$WORDPRESS_DB_HOST"');/"     wordpress/wp-config.php


# generate self-signed certificate
/usr/bin/openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt -subj "/C=SI/ST=Ljubljana/L=Ljubljana/O=Security/OU=IT Department/CN=www.example.com"
a2enmod ssl


# some DNS hooks
IP=$(/sbin/ifconfig | grep inet | head -n1 | awk '{print $2}')
echo "$IP   ssl-demo.muscat.rv.ua" >> /etc/hosts


# START!
/usr/sbin/a2dissite 000-default
/usr/sbin/a2ensite wordpress
/usr/sbin/a2ensite wordpress-SSL

/etc/init.d/apache2 start


# there is no httpd -D FOREGROUND, so...
while :; do :; done
