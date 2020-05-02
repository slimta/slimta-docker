#!/bin/bash -e

[ -n "$DOMAINS" ] || { echo "empty \$DOMAINS"; exit 1; }
[ -f $LEXICON_ENV ] || { echo "invalid \$LEXICON_ENV"; exit 1; }
[ -d $OUTDIR ] || { echo "invalid \$OUTDIR"; exit 1; }

dehydrated --register --accept-terms

domain_args=""
for domain in $DOMAINS; do
	link_var="DOMAIN_LN_$domain"
	link_dest=${!link_var}
	if [ -n "$link_dest" ]; then
		ln -sf $link_dest $OUTDIR/$domain
		domain=$link_dest
	fi
	domain_args="$domain_args --domain $domain"
done

source $LEXICON_ENV

while true; do
	dehydrated --cron \
		--hook /usr/local/bin/lexicon-hook.sh \
		--challenge dns-01 \
		--out $OUTDIR \
		$domain_args

	sleep_for=$(datediff now "$(dateadd today +1d) 03:00" -f %Ss)
	echo "Sleeping $sleep_for..."
	sleep $sleep_for
done
