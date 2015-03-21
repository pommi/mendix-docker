# Dockerfile
#
# VERSION               0.2

FROM debian:latest
MAINTAINER Pim van den Berg <pim.van.den.berg@mendix.com>

RUN apt-key adv --fetch-keys http://packages.mendix.com/mendix-debian-archive-key.asc
RUN echo "deb http://packages.mendix.com/platform/debian/ wheezy main" > /etc/apt/sources.list.d/mendix.list

RUN apt-get update && apt-get install -y --no-install-recommends python-m2ee openjdk-7-jre-headless nginx python-flask postgresql-client procps vim-nox curl && apt-get clean

RUN useradd -m mendix && cd /home/mendix; mkdir -p .m2ee runtimes log data data/files data/model-upload data/database model web tmp

ADD m2ee.yaml /home/mendix/.m2ee/m2ee.yaml
ADD nginx.conf /home/mendix/nginx.conf

RUN chown -R mendix:mendix /home/mendix /var/log/nginx /var/lib/nginx

RUN curl -s -L https://raw.githubusercontent.com/pommi/m2ee-tools/docker/src/m2ee-api.py -o /usr/bin/m2ee-api && chmod +x /usr/bin/m2ee-api

EXPOSE 5000 7000
CMD ["/bin/su", "mendix", "-c", "/usr/bin/m2ee-api"]
