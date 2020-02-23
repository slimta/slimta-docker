#!/bin/bash
set -m

/rule-update.sh &
update_pid=$!

/spamd.sh &
spamd_pid=$!

while true; do
	wait -n
	exitcode=$?
	if ! kill -0 $update_pid > /dev/null 2>&1; then
		>&2 echo "/rule-update.sh terminated"
		kill $spamd_pid > /dev/null 2>&1
		wait $spamd_pid > /dev/null 2>&1
		exit $exitcode
	elif ! kill -0 $spamd_pid > /dev/null 2>&1; then
		>&2 echo "/spamd.sh terminated"
		kill $update_pid > /dev/null 2>&1
		wait $update_pid > /dev/null 2>&1
		exit $exitcode
	fi
done
