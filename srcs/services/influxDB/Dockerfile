FROM alpine:3.12

# Install InfluxDB
RUN apk update && \
	apk add --no-cache influxdb bash

# Copy InfluxDB config
COPY influxdb.conf /etc/influxdb.conf

# Copy Entrypoint
COPY setupinfluxDB.sh /

# Volume to persiting data
# VOLUME /etc/InfluxDB/

EXPOSE 8086

ENTRYPOINT [ "sh", "/setupinfluxDB.sh" ]