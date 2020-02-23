# slimta-docker

Docker configuration for a slimta mail server.

## Building

```bash
git clone https://github.com/slimta/slimta-docker.git
cd slimta-docker
make
```

You will be prompted for several pieces of information. This info
is used to generate a [letsencrypt][1] certificate for your mail
server. See [Lexicon][2] and [dehydrated][3] for more information.

```
FQDN: mail.example.com
DNS provider: cloudflare
Username: user@example.com
Token:
```

The FQDN should be a DNS ***A*** record pointing to this mail server,
e.g. `mail.example.com`. An ***MX*** record on the top-level domain
and a ***PTR*** record on the IP address should point to this FQDN
for effective mail delivery.

## Installing

Currently only systemd-based installations are implemented.

```bash
sudo make install-systemd
```

## Uninstalling

```bash
sudo make uninstall-systemd
make clean
```

[1]: https://letsencrypt.org/
[2]: https://github.com/AnalogJ/lexicon#providers
[3]: https://dehydrated.io/
