# `slimta/pymap` image

Runs a [pymap][1] instance in a Docker container.

### Environment

* `KEY_FILE`: The path to the private key file. Default:
  `/etc/ssl/private/local/privkey.pem`
* `CERT_FILE`: The path to the certificate file. Default:
  `/etc/ssl/private/local/fullchain.pem`
* `REDIS_HOST`: The hostname of the redis instance. Default: `redis`
* `PYMAP_SELECT`: The redis database number to select for mail operations.
  Default: `1`

## slimta-docker

For the full stack of IMAP and SMTP services with [spamassassin][3] and
[letsencrypt][4] certificates, use this image as part of the [slimta-docker][2]
stack.

[1]: https://github.com/icgood/pymap
[2]: https://github.com/slimta/slimta-docker
[3]: https://spamassassin.apache.org/
[4]: https://letsencrypt.org/
