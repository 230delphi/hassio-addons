# docker build --build-arg BUILD_FROM="homeassistant/amd64-base:latest"
ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8
LABEL maintainer="230delphi@gmail.com"


#ENV SQUID_VERSION=5.0 \
#    SQUID_CACHE_DIR=/var/spool/squid \
#    SQUID_LOG_DIR=/var/log/squid \
#    SQUID_USER=proxy

#RUN apk add --no-cache golang

#COPY entrypoint.sh /sbin/entrypoint.sh
#RUN chmod 755 /sbin/entrypoint.sh

#EXPOSE 3128/tcp
#ENTRYPOINT ["/sbin/entrypoint.sh"]

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh
CMD [ "/run.sh" ]
