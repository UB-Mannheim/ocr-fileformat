FROM alpine:edge

MAINTAINER Konstantin Baierer <konstantin.baierer@gmail.com>

EXPOSE 8080
ADD . /ocr-fileformat
WORKDIR /ocr-fileformat
RUN apk add --no-cache openjdk8-jre php7 php7-json py-lxml git make ca-certificates wget bash \
    && update-ca-certificates \
    && make install \
    && cp docker.config.php web/config.local.php \
    && mv web /ocr-fileformat-web \
    && rm -rf /ocr-fileformat \
    && apk del git make wget
VOLUME /data
WORKDIR /data
CMD php7 -S $(hostname -i):8080 -t /ocr-fileformat-web
