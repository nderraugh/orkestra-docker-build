FROM maven:3.6-jdk-8-alpine

## --------------------------------- Env variables
ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 18.09.4
ENV SCALA_VERSION 2.12.8
ENV SBT_VERSION 1.2.8

## ------------------------------- Initial Libraries
RUN apk add --update \
  bash \
  wget \
  ca-certificates \
  openssl \
  libgcc \
  libstdc++ \
  bash \
  gettext \
  curl

## SBT
RUN echo "$SCALA_VERSION $SBT_VERSION" && \
  curl -fsL https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz | tar xfz - -C /usr/local && \
  ln -s /usr/local/sbt/bin/* /usr/local/bin/ && \
  sbt sbtVersion

## Docker
RUN \
set -eux; \
apkArch="$(apk --print-arch)"; \
case "$apkArch" in \
    x86_64) dockerArch='x86_64' ;; \
    armhf) dockerArch='armel' ;; \
    aarch64) dockerArch='aarch64' ;; \
    ppc64le) dockerArch='ppc64le' ;; \
    s390x) dockerArch='s390x' ;; \
    *) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;; \
esac; \
\
if ! wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz"; then \
    echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for '${dockerArch}'"; \
    exit 1; \
fi; \
\
tar --extract \
    --file docker.tgz \
    --strip-components 1 \
    --directory /usr/local/bin/ \
; \
rm docker.tgz; \
\
dockerd --version; \
docker --version

# Cleanup
RUN apk del --no-cache --purge \
  wget \
  curl \
  ca-certificates \
  openssl \
  gettext \
  && rm /var/cache/apk/*

# Not sure if this is necessary but may be helpful for dnd
VOLUME ["/var/run/docker.sock"]