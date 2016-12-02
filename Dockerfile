FROM python:2.7-alpine

MAINTAINER "lenciel"
LABEL project="docker-nginx-uwsgi-django"
LABEL version = "1.0.0"
LABEL author="lenciel"
LABEL author_email="lenciel@gmail.com"

RUN apk add --update \
    --repository http://mirrors.ustc.edu.cn/alpine/v3.4/main/ \
    nginx \
    supervisor \
    python-dev \
    build-base \
    linux-headers \
    pcre-dev \
    py-pip \
    vim \
  && rm -rf /var/cache/apk/* && \
  chown -R nginx:www-data /var/lib/nginx

RUN pip install https://github.com/unbit/uwsgi/archive/uwsgi-2.0.zip#egg=uwsgi

ADD . /app
WORKDIR /app

RUN pip install django

RUN mkdir /etc/nginx/sites-enabled
RUN rm /etc/nginx/nginx.conf
RUN ln -s /app/nginx/nginx.conf /etc/nginx/
RUN ln -s /app/nginx/nginx-app.conf /etc/nginx/sites-enabled/
RUN rm /etc/supervisord.conf
RUN ln -s /app/supervisord/supervisord.conf /etc/

EXPOSE 80

CMD ["supervisord", "-n"]
