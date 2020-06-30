FROM ubuntu:18.04

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean
RUN apt-get update && \
    apt-get install -y python-pip git-core python-dev python-svn python-mysqldb libssl-dev libffi-dev uwsgi libpq-dev wget uwsgi-plugin-python inetutils-ping vim && \
    apt-get clean

ARG dockerize_version=0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/v${dockerize_version}/dockerize-linux-amd64-v${dockerize_version}.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v${dockerize_version}.tar.gz && \
    rm dockerize-linux-amd64-v${dockerize_version}.tar.gz

ARG pip_source=https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install -i ${pip_source} --upgrade pip
RUN pip install -i ${pip_source} -U setuptools cryptography python-memcached psycopg2

ARG reviewboard_version=3.0.14 
ARG rbtools_version=1.0.1
RUN pip install -i ${pip_source} -U ReviewBoard==$reviewboard_version RBTools==$rbtools_version

VOLUME "/media"
VOLUME "/var/www"
EXPOSE 8000

ENV DB_TYPE mysql 
ENV DB_PORT 3306
ENV DB_NAME reviewboard
ENV DB_USER reviewboard
ENV DB_PASSWORD reviewboard
ENV RB_ADMIN admin
ENV RB_PASSWORD admin
ENV RB_ADMIN_EMAIL admin@example.com
ENV UWSGI_PROCESSES 10

COPY uwsgi.ini /etc/reviewboard/uwsgi.ini
COPY run.sh /etc/reviewboard/run.sh
RUN chmod +x /etc/reviewboard/run.sh

CMD ["/etc/reviewboard/run.sh"]
