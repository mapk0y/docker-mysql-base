FROM ubuntu:12.04
MAINTAINER Kazuya Yokogawa "mapk0y@gmail.com"

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -snvf /bin/true /sbin/initctl

RUN echo "deb http://jp.archive.ubuntu.com/ubuntu/ precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server

RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
ADD init.sql /tmp/
RUN (/usr/bin/mysqld_safe &); sleep 3; mysql -u root < /tmp/init.sql

CMD ["/usr/bin/mysqld_safe"]
