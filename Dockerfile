FROM ubuntu:16.04
MAINTAINER CHEN, Yuelong <yuelong.chen.btr@gmail.com>


ENV DEBIAN_FRONTEND noninteractive
ARG picard_version=2.19.2

# some picard method would use R to plot
#
RUN apt-get update && \
    apt-get install --yes openjdk-8-jdk wget r-base && \
    cd /usr/local/bin && \
    wget https://github.com/broadinstitute/picard/releases/download/$picard_version/picard.jar && \
    chmod +x picard.jar

COPY picard.sh /usr/local/bin/picard
RUN chmod +x /usr/local/bin/picard


# clean
RUN apt-get clean && \
    apt-get remove --yes --purge wget




CMD picard