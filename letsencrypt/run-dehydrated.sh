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
	domain_args="$domain_args $domain"
done

source $LEXICON_ENV

[ -n "$PROVIDER" ] || { echo "empty \$PROVIDER"; exit 1; }
[ -n "$(bash -c 'echo -n $PROVIDER')" ] || { echo "un-exported \$PROVIDER"; exit 1; }

while true; do
	for domain in $domain_args; do
		dehydrated --cron \
			--hook /usr/local/bin/lexicon-hook.sh \
			--challenge dns-01 \
			--out $OUTDIR \
			--domain $domain \
			--domain www.$domain
		pushd $OUTDIR/$domain
		cat fullchain.pem privkey.pem > both.pem
		chmod og-rwx both.pem
		popd
	done

	sleep_for=$(datediff now "$(dateadd today +1d) 03:00" -f %Ss)
	echo "Sleeping $sleep_for..."
	sleep $sleep_for
done
