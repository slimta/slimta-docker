# slimta-docker

Docker configuration for a slimta mail server.

```bash
git clone https://github.com/slimta/slimta-docker.git
cd slimta-docker
```

## Running Locally

To build and run the stack locally, first build it:

```bash
make
```

Now it can be run using [`docker-compose`][1], e.g.:

```bash
docker-compose up -d     # start the app
docker-compose logs -f   # tail the logs
docker-compose down      # stop the app
```

## Address Utility

Redis is used to manage deliverable addresses on the mailserver. The
`./address-util.sh` script can help manage them:

```
usage: ./address-util.sh <command> [data] [address|domain]

commands:
	--list          List all the address records
	--get           Show the current record
	--set           Set the record with the new data
	--update        Add additional data to the record
	--delete        Delete the record

data:
	--mailbox       Make the record a deliverable mailbox, with password
	--alias VAL     Make the record an alias to VAL
```

Examples:

```bash
# List all configured addresses
./address-util.sh --list

# Add a new mailbox for address 'test@example.com'
./address-util.sh --set --mailbox test@example.com

# Add an alias from 'alias@example.com' to 'test@example.com'
./address-util.sh --set --alias test@example.com alias@example.com

# Add an alias for all 'other.com' addresses, e.g. 'foo@other.com' would
# alias to 'test+foo@example.com'
./address-util.sh --set --alias 'test+{localpart}@example.com' other.com

# Get the raw JSON configuration for 'test@example.com'
./address-util.sh --get test@example.com

# Delete the configuration for 'test@example.com'
./address-util.sh --delete test@example.com
```

[1]: https://docs.docker.com/compose/reference/
