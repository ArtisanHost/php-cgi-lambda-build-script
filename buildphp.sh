#!/bin/sh
# This script builds a docker container based on AWS and compiles PHP
# Then moves the php-cgi binary out of the container before removing.

# source from https://github.com/php/php-src
if [ $# -lt 1 ]; then
  echo
  echo "Usage: $0 VERSION"
  echo "Build shared libraries for php and its dependencies via containers"
  echo
  echo "Please specify the php VERSION, e.g. 7.2.0 7.1.5, 7.0.20"
  echo
  exit 1
fi
#Set the number of jobs while compiling, Good rule is one more than physical cores
JOBS=5

PHP_VERSION_GIT_BRANCH="php-$1"

# Set the build arguments you want to compile PHP with. remembering to keep it as small as you can
BUILD_ARGUMENTS="--disable-dependency-trackin \
--disable-opcache \
--disable-static \
--enable-bcmath \
--enable-calendar \
--enable-ctype \
--enable-exif \
--enable-ftp \
--enable-gd-jis-conv \
--enable-gd-native-ttf \
--enable-json \
--enable-mbstring \
--enable-pcntl \
--enable-pdo \
--enable-shared \
--enable-shared=yes \
--enable-static=no \
--enable-sysvmsg \
--enable-sysvsem \
--enable-sysvshm \
--enable-zip \
--prefix=${TARGET} \
--with-config-file-path=${TARGET}/usr/etc \
--with-curl=${TARGET} \
--with-gd \
--with-gmp \
--with-iconv \
--with-mysqli=mysqlnd \
--with-openssl \
--with-pdo-mysql=mysqlnd \
--with-zlib \
--without-pear"



echo "Build PHP Binary from current branch '$PHP_VERSION_GIT_BRANCH' on https://github.com/php/php-src"

docker build --build-arg PHP_VERSION=$PHP_VERSION_GIT_BRANCH -t php-build -f dockerfile .

container=$(docker create php-build)
docker -D cp $container:/php-src-$PHP_VERSION_GIT_BRANCH/sapi/cgi/php-cgi .

docker rm $container
