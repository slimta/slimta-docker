# `slimta/letsencrypt` image

Runs [dehydrated][1] daily in a Docker container.

### Environment

* `LEXICON_ENV`: The path to the environment file containing [lexicon][5]
  secrets. Default: `/run/secrets/lexicon_env`
* `OUTDIR`: The path to the output directory for certificates. Default:
  `/etc/ssl/private`

## slimta-docker

For the full stack of IMAP and SMTP services with [spamassassin][3] and
[letsencrypt][4] certificates, use this image as part of the [slimta-docker][2]
stack.

[1]: https://dehydrated.io/
[2]: https://github.com/slimta/slimta-docker
[3]: https://spamassassin.apache.org/
[4]: https://letsencrypt.org/
[5]: https://github.com/AnalogJ/lexicon
