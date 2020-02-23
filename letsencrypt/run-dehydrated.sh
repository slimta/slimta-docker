#!/bin/bash -e

[ -n "$FQDN" ] || { echo "invalid \$FQDN"; exit 1; }

ln -sf $FQDN /etc/ssl/private/local

exec dehydrated --cron \
	--hook /usr/local/bin/lexicon-hook.sh \
	--challenge dns-01 \
	--domain $FQDN \
	--out /etc/ssl/private
