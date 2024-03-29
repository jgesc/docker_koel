FROM php:8.1.8-apache-bullseye

# Install NodeJS, Yarn
RUN apt-get update && apt-get -y dist-upgrade && apt-get install -y \
	gnupg2 \
	apt-transport-https \
	git && \
	curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
	apt-get update && \
	apt-get install -y nodejs yarn

# Install Composer
RUN curl -sS https://getcomposer.org/installer \
    | php -- \
          --install-dir=/usr/local/bin \
          --filename=composer \
          --version=2.3.10 && \
	chmod +x /usr/local/bin/composer && \
	composer --version

# Install apt libraries
RUN apt-get install -y \
	libxml2-dev zlib1g-dev libcurl4-openssl-dev libc6-dev libpng-dev faad sudo \
	ffmpeg libzip-dev libjpeg62-turbo-dev zip libfreetype6-dev libapache2-mod-xsendfile \
	locales libonig-dev libpq-dev python2-minimal libvorbis-dev

RUN apt-get clean

# Install php libraries
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install -j$(nproc) \
	zip mbstring curl xml exif pdo pdo_mysql pdo_pgsql pgsql gd bcmath

# Download and install koel
RUN git clone https://github.com/koel/koel.git -b "v6.0.2" --recurse-submodules --single-branch --depth 1 /var/www/html && \
  cd /var/www/html && \
  rm -rf .editorconfig \
    .eslintignore \
    .eslintrc \
    .git \
    .gitattributes \
    .github \
    .gitignore \
    .gitmodules \
    .gitpod.dockerfile \
    .gitpod.yml \
    .travis.yml \
    cypress \
    cypress.json \
    nitpick.json \
    tests

WORKDIR /var/www/html
RUN composer install --no-dev --optimize-autoloader
WORKDIR /var/www/html/resources/assets
RUN yarn install --non-interactive
WORKDIR /var/www/html
RUN CYPRESS_INSTALL_BINARY=0 yarn install --non-interactive
RUN yarn build

# Remove default configuration file and more cleanup
RUN rm -rf .env \
    api-docs \
    package.json \
    phpstan.neon.dist \
    phpunit.xml \
    phpunit.xml.dist \
    node_modules \
    resources/artifacts \
    ruleset.xml \
    scripts/ \
    tag.sh \
    vite.config.js

ENV FFMPEG_PATH=/usr/bin/ffmpeg \
    MEDIA_PATH=/music \
    STREAMING_METHOD=x-sendfile \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Koel makes use of Larvel's pretty URLs. This requires some additional
# configuration: https://laravel.com/docs/4.2#pretty-urls
COPY ./.htaccess /var/www/html/public

# Fix permissions.
RUN chown -R www-data:www-data /var/www/html \
  # Set locale to prevent removal of non-ASCII path characters when transcoding with ffmpeg
  # See https://github.com/koel/docker/pull/91
  && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
  && /usr/sbin/locale-gen

RUN a2enmod rewrite

# Enable HTTPS
COPY koel-ssl.conf /etc/apache2/sites-available
RUN a2enmod ssl && \
    a2ensite koel-ssl && \
    a2dissite 000-default

# Copy custom init command (no longer needed with --no-assets)
#COPY InitCommand.php /var/www/html/app/Console/Commands/

# Setup bootstrap script.
COPY koel-entrypoint /usr/local/bin/
ENTRYPOINT ["koel-entrypoint"]
CMD ["apache2-foreground"]

EXPOSE 443
