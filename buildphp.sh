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
JOBS=24

PHP_VERSION_GIT_BRANCH="php-$1"

# Set the build arguments you want to compile PHP with. remembering to keep it as small as you can
BUILD_ARGUMENTS="--enable-static=yes \
    --enable-shared=no \
    --enable-hash \
    --enable-json \
    --enable-libxml \
    --enable-mbstring \
    --enable-phar \
    --enable-soap \
    --enable-xml \
    --with-curl \
    --with-gd \
    --with-zlib \
    --with-openssl \
    --without-pear \
    --enable-ctype \
    --enable-cgi \
    --with-mysqli=mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --enable-opcache \
    --enable-bcmath \
    --enable-exif \
    --enable-zip \
    --enable-opcache-file \
    --with-config-file-path=/var/task/"


echo "Build PHP Binary from current branch '$PHP_VERSION_GIT_BRANCH' on https://github.com/php/php-src"

docker build --build-arg PHP_VERSION=$PHP_VERSION_GIT_BRANCH --build-arg BUILD_ARGUMENTS="$BUILD_ARGUMENTS" --build-arg JOBS=$JOBS -t php-build -f dockerfile .

container=$(docker create php-build)
docker -D cp $container:/php-src-$PHP_VERSION_GIT_BRANCH/sapi/cgi/php-cgi .
docker -D cp $container:/php-src-$PHP_VERSION_GIT_BRANCH/sapi/cli/php .
docker -D cp $container:/php-src-$PHP_VERSION_GIT_BRANCH/modules/opcache.so .
docker -D cp $container:/php-src-$PHP_VERSION_GIT_BRANCH/ext/opcache/.libs/opcache.so ./opcache2.so
docker -D cp $container:/usr/bin/ssh ./ssh

docker rm $container

