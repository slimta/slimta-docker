
SHELL := /bin/bash

.PHONY: all
all: build next-steps

.PHONY: build
build: config
	docker-compose build

.PHONY: up
up: build
	docker-compose up

.PHONY: push
push: build
	docker-compose push

.PHONY: deploy
deploy: push
	$(shell cat .env) docker stack deploy -c docker-compose.yml slimta-docker

.PHONY: next-steps
next-steps:
	$(warning )
	$(warning Use 'make up' or 'make deploy':)
	$(warning - 'make up' starts the app using 'docker-compose up')
	$(warning - 'make deploy' uses docker swarm mode to deploy the app)
	$(warning )
	$(warning See: https://github.com/slimta/slimta-docker/blob/master/README.md)

.PHONY: config
config: .env lexicon.env

.env:
	echo; echo "Enter the fully-qualified domain name of this server, e.g. 'mail.example.com':"; echo; \
	read -p "FQDN: " fqdn; \
	echo -en "FQDN=$$fqdn\n" > $@

lexicon.env:
	echo; echo "Enter your DNS provider information, for automated Let's Encrypt certificates:"; echo; \
	read -p "DNS provider: " provider; \
	read -p "Username: " username; \
	stty -echo; read -p "Token: " token; stty echo; echo; \
	provider_up=$$(echo $${provider} | tr "[a-z]" "[A-Z]"); \
	echo -en "PROVIDER=$$provider\nLEXICON_$${provider_up}_USERNAME=$$username\nLEXICON_$${provider_up}_TOKEN=$$token\n" > $@
	chmod o-rwx $@
