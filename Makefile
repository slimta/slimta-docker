
SHELL := /bin/bash

.PHONY: all
all: build next-steps

.PHONY: build
build: config
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
deploy: config pull
	$(shell cat .env) docker stack deploy -c docker-compose.yml slimta-docker

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
