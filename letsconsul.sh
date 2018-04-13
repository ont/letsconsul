#!/bin/sh
set -e

IFS=";"
for group in $LETSCONSUL_DOMAINS
do
    echo
    echo "-----------------------"
    IFS=" "
    domains=""
    domain_main=""
    for domain in $group
    do
        if [ "$domain_main" = "" ]
        then
            domain_main=$domain
        fi
        domains="$domains -d $domain"
    done

    certbot \
        --non-interactive \
        --no-bootstrap \
        --no-self-upgrade \
        --no-eff-email \
        --staple-ocsp \
        --agree-tos \
        --renew-by-default \
        --standalone \
        --preferred-challenges http \
        --http-01-port 7777 \
        certonly $domains -m $LETSCONSUL_EMAIL

    curl -XPUT --data-bin @/etc/letsencrypt/live/$domain_main/privkey.pem http://$LETSCONSUL_CONSUL_URL:8500/v1/kv/letsconsul/$domain_main/privkey
    curl -XPUT --data-bin @/etc/letsencrypt/live/$domain_main/fullchain.pem http://$LETSCONSUL_CONSUL_URL:8500/v1/kv/letsconsul/$domain_main/fullchain

done


