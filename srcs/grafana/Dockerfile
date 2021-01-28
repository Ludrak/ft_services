FROM alpine:3.12

RUN apk update && \
	apk add --no-cache \
	curl \
	libc6-compat

RUN wget https://dl.grafana.com/oss/release/grafana-7.3.7.linux-amd64.tar.gz\
    && tar -zxvf grafana-7.3.7.linux-amd64.tar.gz \
	&& mv grafana-7.3.7 etc/grafana \
	&& rm grafana-7.3.7.linux-amd64.tar.gz

# Creating Grafana User
RUN adduser -DH -g 'grafana' grafana && \
	chown -R grafana:grafana /etc/grafana && \
	chmod -R 744 /etc/grafana

# Installation
RUN	ln -s /etc/grafana/bin/grafana-cli /usr/bin && \
	ln -s /etc/grafana/bin/grafana-server /usr/bin

COPY launch.sh ./launch.sh

EXPOSE 3000

CMD ./launch.sh