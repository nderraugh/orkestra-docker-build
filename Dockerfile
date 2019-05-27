FROM docker:dind

## --------------------------------- Env variables
ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 18.09.4
ENV SCALA_VERSION 2.12.6
ENV SBT_VERSION 1.2.1

## ------------------------------- Initial Libraries
RUN apk add --update \
  bash \
  wget \
  ca-certificates \
  openssl \
  libgcc \
  libstdc++ \
  gettext \
  curl \
  git \
  openjdk8

## SBT
RUN echo "$SCALA_VERSION $SBT_VERSION" && \
  curl -fsL https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz | tar xfz - -C /usr/local && \
  ln -s /usr/local/sbt/bin/* /usr/local/bin/ && \
  sbt sbtVersion

RUN mkdir /src; \
  cd /src; \
  git clone https://github.com/nderraugh/orkestra-bootstrap; \
  cd ./orkestra-bootstrap; \
  sbt compile;

COPY gcr-creds.json ./gcr-creds.json

RUN cat gcr-creds.json | docker login -u _json_key --password-stdin https://gcr.io/

ENTRYPOINT dockerd &