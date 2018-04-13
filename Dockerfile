FROM alpine

ENV LETSCONSUL_CONSUL_URL consul.service.consul
ENV LETSCONSUL_EMAIL no-reply@test.com

RUN apk add --no-cache certbot curl

COPY letsconsul.sh /letsconsul.sh

EXPOSE 7777
ENTRYPOINT ["/letsconsul.sh"]
