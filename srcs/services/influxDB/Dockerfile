FROM alpine:3.12

# Install InfluxDB
RUN apk update && \
	apk upgrade --no-cache &&\
	apk add --no-cache influxdb bash

# Copy InfluxDB config
COPY ./config/influxdb.conf /etc/influxdb.conf

# Copy Entrypoint
COPY config/setupinfluxDB.sh /
RUN chmod +x setupinfluxDB.sh

# install telegraf
RUN     apk add libc6-compat gcompat \
        && wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz

RUN     tar xf telegraf-1.15.2_linux_amd64.tar.gz -C / \
        && rm telegraf-1.15.2_linux_amd64.tar.gz

COPY    config/telegraf/telegraf.conf /etc/telegraf/

# Volume to persiting data
# VOLUME /etc/InfluxDB/

EXPOSE 8086 8088

ENTRYPOINT [ "sh", "/setupinfluxDB.sh" ]