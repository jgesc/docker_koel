FROM php:7.3.0-apache

# Install NodeJS, Yarn
RUN apt-get update && apt-get install -y \
	gnupg2 \
	apt-transport-https \
	git && \
	curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
	apt-get update && \
	apt-get install -y nodejs yarn

# Install Composer
RUN curl -sS https://getcomposer.org/installer \
    | php -- \
          --install-dir=/usr/local/bin \
          --filename=composer \
          --version=1.9.0 && \
	chmod +x /usr/local/bin/composer && \
	composer --version

# Install apt libraries
RUN apt-get install -y \
	libxml2-dev zlib1g-dev libcurl4-openssl-dev libc6-dev libpng-dev faad ffmpeg libzip-dev

# Install php libraries
RUN docker-php-ext-install \
	zip mbstring curl xml exif pdo pdo_mysql

# Download and install koel
RUN git clone https://github.com/phanan/koel.git -b v4.1.1 --recursive /var/www/html
WORKDIR /var/www/html
RUN composer install
WORKDIR /var/www/html/resources/assets
RUN yarn install
WORKDIR /var/www/html
RUN yarn install
RUN yarn production

# Remove default configuration file
RUN rm /var/www/html/.env

# Koel makes use of Larvel's pretty URLs. This requires some additional
# configuration: https://laravel.com/docs/4.2#pretty-urls
COPY ./.htaccess /var/www/html

# Fix permissions.
RUN chown -R www-data:www-data /var/www/html
RUN a2enmod rewrite

# Enable HTTPS
COPY koel-ssl.conf /etc/apache2/sites-available
RUN a2enmod ssl && \
    a2ensite koel-ssl && \
	a2dissite 000-default

# Copy custom init command
COPY InitCommand.php /var/www/html/app/Console/Commands/

# Setup bootstrap script.
COPY koel-entrypoint /usr/local/bin/
ENTRYPOINT ["koel-entrypoint"]
CMD ["apache2-foreground"]

EXPOSE 443
