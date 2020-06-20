FROM php:7.4-apache

LABEL maintainer="ivann.laruelle@gmail.com"

ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    apt-get update && apt-get install -y vim git zip unzip rsync nano && \
    install-php-extensions gd intl ctype curl phar filter iconv ldap mcrypt bcmath xdebug imap mongodb pgsql oauth pdo_pgsql pdo_dblib pdo_firebird pdo_odbc pdo_sqlsrv sqlsrv yaml json pdo simplexml xml tokenizer xmlwriter xmlreader pdo_mysql zip intl && \
    apt-get autoremove -y && a2enmod rewrite && git clone -b v1.0-rc9 https://github.com/Flyspray/flyspray.git /var/www/html && \
    chgrp -R 0 /var/www/html && chmod g+rwx -R /var/www/html && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php --install-dir=/usr/bin/ --filename=composer && php -r "unlink('composer-setup.php');"

COPY site.conf /etc/apache2/sites-available/000-default.conf
COPY ports.conf /etc/apache2/ports.conf
COPY entrypoint.sh /bin/entrypoint.sh

EXPOSE 8080

WORKDIR /var/www/html

RUN composer install && chmod +x /bin/entrypoint.sh

USER 1520:0

ENTRYPOINT "/bin/entrypoint.sh"