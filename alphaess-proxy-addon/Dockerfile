# docker build --build-arg BUILD_FROM="homeassistant/amd64-base:latest"
ARG BUILD_FROM
FROM $BUILD_FROM

LABEL maintainer="230delphi@gmail.com"
ENV LANG C.UTF-8

# Setup base
RUN apk add --no-cache git go

# Configure Go
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH
RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

#COPY entrypoint.sh /sbin/entrypoint.sh
#RUN chmod 755 /sbin/entrypoint.sh

#EXPOSE 3128/tcp
#ENTRYPOINT ["/sbin/entrypoint.sh"]

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh
CMD [ "/run.sh" ]
