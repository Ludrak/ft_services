#!/bin/bash

#launch telegraf
cd /telegraf-1.15.2/usr/bin/ && ./telegraf &
cd /

set -e

CA_CERT="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
BEARER="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"
STAT_URL="https://kubernetes/api/v1/namespaces/default/services/ftps-loadbalancer"
STAT_DATA=$(curl --cacert "$CA_CERT" -H "Authorization: Bearer $BEARER" "$STAT_URL")
HOST="$(echo "$STAT_DATA" | jq -r '.status.loadBalancer.ingress[0].ip')"

echo "Generating ssl cert"
openssl req -x509 -nodes \
        -days 365 \
        -subj "/C=FR/ST=69/O=Company, Inc./CN=$HOST" \
        -addext "subjectAltName=DNS:$HOST" \
        -newkey rsa:2048 \
        -keyout $SSL_KEY \
        -out    $SSL_CERT

echo "Setting PASV IP to '$HOST'..."
sed -i "$FTP_CONF" -e "s|HOST|$HOST|g" \
                -e "s|MIN_PORT|$FTP_MIN_PORT|g" \
                -e "s|MAX_PORT|$FTP_MAX_PORT|g" \
                -e "s|SSL_CERT|$SSL_CERT|g" \
                -e "s|SSL_KEY|$SSL_KEY|g"

echo "Starting vsftpd"
vsftpd $FTP_CONF