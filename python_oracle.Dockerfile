ARG PYTHON_VERSION=3.6
ARG ORACLE_VERSION=11.2

FROM ubuntu:16.04 AS ubuntu
LABEL maintainer="aponder <it@aponder.top>"

ARG ORACLE_VERSION

WORKDIR /root
# this can be downloaded from https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
ENV CLIENT_ZIP=instantclient-basic-linux.x64-${ORACLE_VERSION}.*.zip
ENV SDK_ZIP=instantclient-sdk-linux.x64-${ORACLE_VERSION}.*.zip
RUN echo ${CLIENT_ZIP}

COPY ${CLIENT_ZIP} ${SDK_ZIP} ./

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && apt-get update -y
RUN apt-get -yq install unzip \
	&& apt-get clean \
	# ^^ finish apt-get ^^
    && unzip ${CLIENT_ZIP} \
    && unzip ${SDK_ZIP} \
	&& mkdir oracle \
    && mv instantclient*/* oracle/

FROM python:${PYTHON_VERSION}
LABEL maintainer="aponder <it@aponder.top>"

ENV HOME /root
ENV ORACLE_HOME /opt/oracle
ENV TNS_ADMIN ${ORACLE_HOME}/network/admin
VOLUME ["${TNS_ADMIN}"]

COPY --from=ubuntu /root/oracle ${ORACLE_HOME}

RUN sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && sed -i s@/security.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && apt-get update -y
RUN apt-get -yq install libaio1 \
	&& apt-get -yq autoremove \
	&& apt-get clean \
	# Install Oracle Instant Client
	&& echo ${ORACLE_HOME} > /etc/ld.so.conf.d/oracle.conf \
	&& mkdir -p ${TNS_ADMIN} \
	&& ldconfig \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
