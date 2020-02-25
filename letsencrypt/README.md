# `slimta/letsencrypt` image

Runs [dehydrated][1] daily in a Docker container.

### Environment

* `DOMAINS`: The domains to generate certificates for. Default: empty
* `LEXICON_ENV`: The path to the environment file containing [lexicon][5]
  secrets. Default: `/run/secrets/lexicon_env`
* `OUTDIR`: The path to the output directory for certificates. Default:
  `/etc/ssl/private`

#### Symbolic linking

To provide applications with consistent paths, the entries in `$DOMAINS` can
also be short names that will be linked to the full domain name, e.g.:

```bash
DOMAINS="mail www.example.com"
DOMAIN_LN_mail="mail.example.com"
```

That will generate certificates for `mail.example.com` and `www.example.com`,
and it will create a symbolic link from `mail` to `mail.example.com` in the
output directory.

## slimta-docker

For the full stack of IMAP and SMTP services with [spamassassin][3] and
[letsencrypt][4] certificates, use this image as part of the [slimta-docker][2]
stack.

[1]: https://dehydrated.io/
[2]: https://github.com/slimta/slimta-docker
[3]: https://spamassassin.apache.org/
[4]: https://letsencrypt.org/
[5]: https://github.com/AnalogJ/lexicon
