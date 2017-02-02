# Dockerfile
#
# VERSION               0.4

FROM debian:jessie-backports
MAINTAINER Pim van den Berg <pim.van.den.berg@mendix.com>

RUN apt-key adv --fetch-keys http://packages.mendix.com/mendix-debian-archive-key.asc
RUN echo "deb http://packages.mendix.com/platform/debian/ jessie main" > /etc/apt/sources.list.d/mendix.list

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates-java=20161107~bpo8+1 m2ee-tools openjdk-8-jre-headless postgresql-client procps vim-nox curl && apt-get clean

RUN useradd -m mendix -b /srv && cd /srv/mendix && mkdir .m2ee data model runtimes web
ADD m2ee.yaml /srv/mendix/.m2ee/m2ee.yaml
RUN chown -R mendix:mendix /srv/mendix

ENV MXDATA /srv/mendix/data
VOLUME /srv/mendix/data

COPY entrypoint /

ENTRYPOINT ["/entrypoint"]

EXPOSE 8000
CMD ["setup"]
