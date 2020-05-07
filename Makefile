
SHELL := /bin/bash

SECRETS_DIR ?= $(HOME)/.docker-secrets
SECRETS := $(SECRETS_DIR)/lexicon.env

.PHONY: all
all: build next-steps

.PHONY: build
build:
	docker-compose build $(SERVICES)

.PHONY: clean
clean:
	docker-compose down --rmi all

.PHONY: push
push: build
	docker-compose push $(SERVICES)

.PHONY: pull
pull:
	docker-compose pull $(SERVICES)

.PHONY: deploy
deploy: config pull stack-deploy

.PHONY: stack-deploy
stack-deploy: export FQDN = $(shell source .env > /dev/null && echo $${FQDN})
stack-deploy:
	docker stack deploy --with-registry-auth -c docker-compose.yml slimta-docker

.PHONY: next-steps
next-steps:
	$(warning )
	$(warning To run the app with docker-compose:)
	$(warning $$ docker-compose up -d     # start the app)
	$(warning $$ docker-compose logs -f   # tail the logs)
	$(warning $$ docker-compose down      # stop the app)
	$(warning )
	$(warning See:)
	$(warning - https://github.com/slimta/slimta-docker/blob/master/README.md)
	$(warning - https://docs.docker.com/compose/reference/)

.PHONY: config
config: .env $(SECRETS_DIR) $(SECRETS)

.env:
	echo; echo "Enter the fully-qualified domain name of this server, e.g. 'mail.example.com':"; echo; \
	read -p "FQDN: " fqdn; \
	echo -en "FQDN=$$fqdn\n" > $@

$(SECRETS_DIR):
	mkdir -p $@
	chmod og-rwx $@

$(SECRETS_DIR)/lexicon.env:
	echo; echo "Enter your DNS provider information, for automated Let's Encrypt certificates:"; echo; \
	read -p "DNS provider: " provider; \
	read -p "Username: " username; \
	stty -echo; read -p "Token: " token; stty echo; echo; \
	provider_up=$$(echo $${provider} | tr "[a-z]" "[A-Z]"); \
	echo -en "export PROVIDER=$$provider\nexport LEXICON_$${provider_up}_USERNAME=$$username\nexport LEXICON_$${provider_up}_TOKEN=$$token\n" > $@
