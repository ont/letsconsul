# Letsconsul
Small utility around certbot for obtaining and saving letsencrypt certificates in consul kv storage.

## How to run

First, prepare nginx for each domain. Add this special `location` to each `server` section:
```
location /.well-known {
    proxy_pass http://ip-addr:7777
}
```
Where `ip-addr` is ip address of machine on which nginx is running.

Then run `letsconsul` with this command.
```bash
docker run
    --rm
    -ti
    -e LETSCONSUL_DOMAINS="example.domain.com www.example.domain.com; second.com; aaa.third.com bbb.third.com"
    -e LETSCONSUL_EMAIL="some@email.com"
    -e LETSCONSUL_CONSUL_URL=ip-addr-of-consul
    -p 7777:7777
    registry.wachanga.com/wachanga/letsconsul
```

`LETSCONSUL_DOMAINS` — is list of domains for SSL certificates generation.
`LETSCONSUL_EMAIL` — email for letsencrypt notifications.
`LETSCONSUL_CONSUL_URL` — url for connection to consul.
`-p 7777:7777` — is necessary for letsencrypt challenge request which will be send to `/.well-known` route and proxied to letsconsul's port `7777`.

For example value `example.domain.com www.example.domain.com; second.com; aaa.third.com bbb.third.com`
there were generated three certificates:
 * for domains `example.domain.com`,  `www.example.domain.com`
 * for domain `second.com`
 * and for domains `aaa.third.com` and `bbb.third.com`

Each new "group" of domains which belong to same certificate must be separated with `;`.

After successful run you will be able to find these keys in consul:
 * `letsconsul/example.domain.com/fullchain`
 * `letsconsul/example.domain.com/privkey`
 * `letsconsul/second.com/fullchain`
 * `letsconsul/second.com/privkey`
 * `letsconsul/aaa.third.com/fullchain`
 * `letsconsul/aaa.third.com/privkey`

As you can notice first domain in group will be used as "main" domain for key naming.
