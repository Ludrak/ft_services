FROM alpine:3.12

RUN apk update && \
	apk add --no-cache \
	curl \
	libc6-compat

RUN wget https://dl.grafana.com/oss/release/grafana-7.3.7.linux-amd64.tar.gz\
    && tar -zxvf grafana-7.3.7.linux-amd64.tar.gz \
	&& mv grafana-7.3.7 etc/grafana \
	&& rm grafana-7.3.7.linux-amd64.tar.gz

# install telegraf
RUN     apk add libc6-compat gcompat \
        && wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz

RUN     tar xf telegraf-1.15.2_linux_amd64.tar.gz -C / \
        && rm telegraf-1.15.2_linux_amd64.tar.gz

COPY    config/telegraf/telegraf.conf /etc/telegraf/

# Creating Grafana User
RUN adduser -DH -g 'grafana' grafana && \
	chown -R grafana:grafana /etc/grafana && \
	chmod -R 744 /etc/grafana

# Installation
RUN	ln -s /etc/grafana/bin/grafana-cli /usr/bin && \
	ln -s /etc/grafana/bin/grafana-server /usr/bin

COPY config/launch.sh		./launch.sh
# COPY config/grafana.ini	etc/grafana/grafana.ini
COPY config/Influxdb.yaml	etc/grafana/conf/provisioning/datasources/

EXPOSE 3000

ENTRYPOINT [ "/bin/sh", "/launch.sh"]