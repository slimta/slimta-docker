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

## Address Management

Redis is used to manage deliverable addresses on the mailserver. The
`pymap-admin` tool can help manage them:

```
usage: pymap-admin [-h] [--version] [--outfile PATH] [--host HOST] [--port PORT] {append,delete-user,get-user,list-users,ping,set-user} ...

Admin functions for a running pymap server.

positional arguments:
  {append,delete-user,get-user,list-users,ping,set-user}
                        which admin command to run
    append              append a message to a mailbox
    delete-user         delete a user
    get-user            get a user
    list-users          list users
    ping                ping the server
    set-user            assign a password to a user

optional arguments:
  -h, --help            show this help message and exit
  --version             show program's version number and exit
  --outfile PATH        the output file (default: stdout)
  --host HOST           host to connect to
  --port PORT           port to connect to
```

Examples:

```bash
# List all configured addresses
pymap-admin list-users

# Add a new mailbox for address 'test@example.com'
pymap-admin set-user test@example.com

# Add an alias from 'alias@example.com' to 'test@example.com'
pymap-admin set-user alias@example.com --no-password \
    --param alias test@example.com

# Add an alias for all 'other.com' addresses, e.g. 'foo@other.com' would
# alias to 'test+foo@example.com'
pymap-admin set-user other.com --no-password \
    --param alias 'test+{localpart}@example.com'

# Get the raw user configuration for 'test@example.com'
pymap-admin get-user test@example.com

# Delete the configuration for 'test@example.com'
pymap-admin delete-user test@example.com
```

[1]: https://docs.docker.com/compose/reference/
