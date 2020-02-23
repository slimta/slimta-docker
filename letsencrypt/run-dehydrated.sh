#!/bin/bash -e

[ -n "$FQDN" ] || { echo "invalid \$FQDN"; exit 1; }

register.sh

ln -sf $FQDN /etc/ssl/private/local

while true; do
	dehydrated --cron \
		--hook /usr/local/bin/lexicon-hook.sh \
		--challenge dns-01 \
		--domain $FQDN \
		--out /etc/ssl/private

	sleep_for=$(datediff now "$(dateadd today +1d) 03:00" -f %Ss)
	echo "Sleeping $sleep_for..."
	sleep $sleep_for
done
