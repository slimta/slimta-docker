
SHELL := /bin/bash
SYSTEM ?= systemd

all: letsencrypt compose

.PHONY: letsencrypt
letsencrypt: /opt/slimta-docker/etc/host.env /opt/slimta-docker/etc/lexicon.env
	docker build --tag letsencrypt letsencrypt

.PHONY: compose
compose: /opt/slimta-docker/etc/host.env
	docker-compose build

.PHONY: clean
clean:
	docker-compose down --rmi all

/opt/slimta-docker/etc/:
	mkdir -p $@
	chown root:docker $@
	chmod g+rx,g-w,o-rwx $@

/opt/slimta-docker/etc/host.env: | /opt/slimta-docker/etc/
	echo; \
	read -p "FQDN: " fqdn; \
	echo -en "FQDN=$$fqdn\n" > $@

/opt/slimta-docker/etc/lexicon.env: | /opt/slimta-docker/etc/
	echo; echo "See: https://github.com/AnalogJ/lexicon#providers"; \
	read -p "DNS provider: " provider; \
	read -p "Username: " username; \
	stty -echo; read -p "Token: " token; stty echo; echo; \
	echo -en "PROVIDER=$$provider\nLEXICON_$${provider^^}_USERNAME=$$username\nLEXICON_$${provider^^}_TOKEN=$$token\n" > $@

/etc/ssl/private/local/privkey.pem: | letsencrypt
	/opt/slimta-docker/bin/check-certs

.PHONY: install
install: all /etc/ssl/private/local/privkey.pem install-$(SYSTEM)

.PHONY: uninstall
uninstall: uninstall-$(SYSTEM)

.PHONY: install-systemd
install-systemd:
	cp -f systemd/slimta-docker.service /etc/systemd/system/
	cp -f systemd/slimta-docker-watch-certs.path /etc/systemd/system/
	cp -f systemd/slimta-docker-watch-certs.service /etc/systemd/system/
	cp -f systemd/slimta-docker-check-certs.timer /etc/systemd/system/
	cp -f systemd/slimta-docker-check-certs.service /etc/systemd/system/
	systemctl daemon-reload
	systemctl enable --now slimta-docker.service

.PHONY: uninstall-systemd
uninstall-systemd:
	systemctl disable --now 'slimta-docker.service'
	rm -f /etc/systemd/system/slimta-docker.service
	rm -f /etc/systemd/system/slimta-docker-watch-certs.path
	rm -f /etc/systemd/system/slimta-docker-watch-certs.service
	rm -f /etc/systemd/system/slimta-docker-check-certs.timer
	rm -f /etc/systemd/system/slimta-docker-check-certs.service
	systemctl daemon-reload

.PHONY: install-none
install-none:

.PHONY: uninstall-none
uninstall-none:
