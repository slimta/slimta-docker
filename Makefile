
SHELL := /bin/bash

.PHONY: all
all: letsencrypt compose

.PHONY: letsencrypt
letsencrypt: config
	docker build --tag letsencrypt letsencrypt

.PHONY: compose
compose: config
	docker-compose build

.PHONY: clean
clean:
	docker-compose down --rmi all

.PHONY: config
config: .env

.env:
	echo; echo "See: https://github.com/slimta/slimta-docker/blob/master/README.md#building"; echo; \
	read -p "FQDN: " fqdn; \
	read -p "DNS provider: " provider; \
	read -p "Username: " username; \
	stty -echo; read -p "Token: " token; stty echo; echo; \
	provider_up=$$(echo $${provider} | tr "[a-z]" "[A-Z]"); \
	echo -en "FQDN=$$fqdn\nPROVIDER=$$provider\nLEXICON_$${provider_up}_USERNAME=$$username\nLEXICON_$${provider_up}_TOKEN=$$token\n" > $@
	chmod o-rwx $@

.PHONY: cert
cert: | letsencrypt
	bin/check-certs $(shell pwd)/.env

.PHONY: install
install:
	$(error Not implemented. Did you mean install-systemd?)

.PHONY: uninstall
uninstall:
	$(error Not implemented. Did you mean uninstall-systemd?)

SYSTEMD_FILES := /etc/systemd/system/slimta-docker.service \
	/etc/systemd/system/slimta-docker-check-certs.service \
	/etc/systemd/system/slimta-docker-check-certs.timer \
	/etc/systemd/system/slimta-docker-watch-certs.service \
	/etc/systemd/system/slimta-docker-watch-certs.path

/etc/systemd/system/%: system/systemd/%
	sed -e 's:{{DIR}}:$(shell pwd):g' system/systemd/$(shell basename $@) > $@

.PHONY: install-systemd
install-systemd: all cert $(SYSTEMD_FILES)
	systemctl daemon-reload
	systemctl enable --now slimta-docker.service

.PHONY: uninstall-systemd
uninstall-systemd:
	systemctl disable --now 'slimta-docker.service'
	rm -f $(SYSTEMD_FILES)
	systemctl daemon-reload
