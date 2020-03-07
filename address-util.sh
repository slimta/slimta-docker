#!/usr/bin/env bash

set -e

command=
record=
mailbox=
alias=

function help {
	echo "usage: $0 <command> [data] [address|domain]"
	echo
	echo "commands:"
	echo "	--list          List all the address records" 
	echo "	--get           Show the current record"
	echo "	--set           Set the record with the new data"
	echo "	--delete        Delete the record"
	echo
	echo "data:"
	echo "	--mailbox       Make the record a deliverable mailbox, with password"
	echo "	--alias VAL     Make the record an alias to VAL"
	exit $1
}

SLIMTA_ADDRESS_PREFIX=${SLIMTA_ADDRESS_PREFIX:-slimta/address/}
PYTHON_CMD=${PYTHON_CMD:-docker_exec_python}
REDIS_CLI_CMD=${REDIS_CLI_CMD:-docker_exec_redis_cli}

function docker_exec_python {
	container_id=$(docker ps | grep "${PYMAP_SERVICE:-slimta-docker_pymap}" | awk '{print $1}')
	docker exec -i $container_id python "$@"
}

function docker_exec_redis_cli {
	container_id=$(docker ps | grep "${REDIS_SERVICE:-slimta-docker_redis}" | awk '{print $1}')
	docker exec -i $container_id redis-cli "$@"
}

function hash_password {
	echo -n "$1" | $PYTHON_CMD -c '
import sys
from passlib.hash import ldap_sha512_crypt
print(ldap_sha512_crypt.using(rounds=40000).hash(sys.stdin.read()))'
}

function build_record {
	$PYTHON_CMD -c "
import json
kwargs = json.loads(\"\"\"$1\"\"\")
if \"\"\"$mailbox\"\"\": kwargs['password'] = \"\"\"$mailbox\"\"\"
if \"\"\"$alias\"\"\": kwargs['alias'] = \"\"\"$alias\"\"\"
print(json.dumps(kwargs))"
}

while [ -n "$1" ]; do
	case "$1" in
		-h | --help)
			help 0
			;;
		--list)
			command=list
			shift
			;;
		--get)
			command=get
			shift
			;;
		--set)
			command=set
			shift
			;;
		--delete)
			command=delete
			shift
			;;
		--mailbox)
			echo -n "Mailbox password: "
			read -s password
			mailbox=$(hash_password $password)
			echo
			shift
			;;
		--alias)
			alias=$2
			shift 2
			;;
		*)
			if [ -z "$record" ]; then
				record=$1
				shift
			else
				>&2 echo "Error: unexpected argument \"$1\""
				help 2
			fi
			;;
	esac
done

if [ "$command" = "list" ]; then
	for addr in $($REDIS_CLI_CMD --raw keys "${SLIMTA_ADDRESS_PREFIX}*"); do
		echo "${addr#${SLIMTA_ADDRESS_PREFIX}}"
	done
	exit 0
fi

if [ -z "$command" ]; then
	>&2 echo "Error: expected command argument"
	help 2
elif [ -z "$record" ]; then
	>&2 echo "Error: expected address or domain argument"
	help 2
fi

if [ "$command" = "get" ]; then
	existing=$($REDIS_CLI_CMD --raw get "${SLIMTA_ADDRESS_PREFIX}$record")
	if [ -n "$existing" ]; then
		echo -n "$existing" | $PYTHON_CMD -m json.tool
	else
		>&2 echo "Error: record does not exist"
		exit 1
	fi
elif [ "$command" = "set" ]; then
	build_record "{}" | $REDIS_CLI_CMD -x set "${SLIMTA_ADDRESS_PREFIX}$record"
elif [ "$command" = "delete" ]; then
	$REDIS_CLI_CMD del "${SLIMTA_ADDRESS_PREFIX}$record"
fi
