# Dockerfile
#
# VERSION               0.2

FROM debian:latest
MAINTAINER Pim van den Berg <pim.van.den.berg@mendix.com>

RUN useradd -m mendix

RUN apt-get update && apt-get install -y --no-install-recommends wget
RUN wget -qO - http://packages.mendix.com/mendix-debian-archive-key.asc | apt-key add -

ADD sources.list /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y --no-install-recommends python-m2ee openjdk-7-jre-headless nginx python-flask postgresql-client
RUN apt-get clean

RUN cd /home/mendix; mkdir -p .m2ee runtimes log data data/files data/model-upload data/database model web tmp

ADD m2ee.yaml /home/mendix/.m2ee/m2ee.yaml
ADD nginx.conf /home/mendix/nginx.conf

RUN chown -R mendix:mendix /home/mendix /var/log/nginx /var/lib/nginx

RUN wget -q https://raw.github.com/pommi/m2ee-tools/docker/src/m2ee-api.py -O /usr/bin/m2ee-api
RUN chmod +x /usr/bin/m2ee-api

EXPOSE 5000 7000
CMD ["/bin/su", "mendix", "-c", "/usr/bin/m2ee-api"]
