#!/bin/bash -e

[ -n "$FQDN" ] || { echo "invalid \$FQDN"; exit 1; }
[ -f $LEXICON_ENV ] || { echo "invalid \$LEXICON_ENV"; exit 1; }
[ -d $OUTDIR ] || { echo "invalid \$OUTDIR"; exit 1; }

register.sh

ln -sf $FQDN $OUTDIR/local

source $LEXICON_ENV

while true; do
	dehydrated --cron \
		--hook /usr/local/bin/lexicon-hook.sh \
		--challenge dns-01 \
		--domain $FQDN \
		--out $OUTDIR

	sleep_for=$(datediff now "$(dateadd today +1d) 03:00" -f %Ss)
	echo "Sleeping $sleep_for..."
	sleep $sleep_for
done
