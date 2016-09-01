FROM alpine:edge

MAINTAINER Konstantin Baierer <konstantin.baierer@gmail.com>

EXPOSE 8080
ADD . /ocr-fileformat
WORKDIR /ocr-fileformat
RUN apk add --no-cache openjdk8-jre php7 php7-json py-lxml git make ca-certificates wget \
    && update-ca-certificates \
    && make install \
    && mv web /ocr-fileformat-web \
    && rm -rf /ocr-fileformat \
    && apk del git make wget
CMD php7 -S $(hostname -i):8080 -t /ocr-fileformat-web
