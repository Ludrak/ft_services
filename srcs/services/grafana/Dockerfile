FROM alpine:3.12

LABEL	maintainer Lecaille Nathan <nlecaill@student.42lyon.fr>

RUN apk update && \
	apk add --no-cache \
	curl \
	libc6-compat \
	openssl \
        openrc

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

COPY	config/Influxdb.yaml	/etc/grafana/conf/provisioning/datasources/
COPY	config/grafana.ini		/etc/grafana/conf
COPY	config/dashboard/ft_services.yaml	/etc/grafana/conf/provisioning/dashboards/
COPY	config/dashboard/*.json   /var/lib/grafana/dashboards/

RUN		mkdir /etc/grafana/ssl
# openssl generation
RUN     openssl req -x509 -nodes \
        -days 365 \
        -subj "/C=FR/ST=69/O=Company, Inc./CN=Grafana" \
        -addext "subjectAltName=DNS:grafana" \
        -newkey rsa:2048 \
        -keyout /etc/grafana/ssl/grafana-selfsigned.key \
        -out    /etc/grafana/ssl/grafana-selfsigned.crt;

# Creating Grafana User
RUN		adduser -DH -g 'grafana' grafana && \
		chown -R grafana:grafana /etc/grafana && \
		chmod -R 744 /etc/grafana

# Installation
RUN		ln -s /etc/grafana/bin/grafana-cli /usr/bin && \
		ln -s /etc/grafana/bin/grafana-server /usr/bin

COPY	config/launch.sh		./launch.sh
# COPY config/grafana.ini	etc/grafana/grafana.ini

EXPOSE 3000

ENTRYPOINT [ "/bin/sh", "/launch.sh"]