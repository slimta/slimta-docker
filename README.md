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
usage: pymap-admin [-h] [--version] [--config PATH] [--host HOST] [--port PORT] [--path PATH] [--token-file PATH] [--cert FILE] [--key FILE] [--cafile FILE] [--capath PATH] [--no-verify-cert] COMMAND ...

Admin functions for a running pymap server. Many arguments may also be given with a $PYMAP_ADMIN_* environment variable.

positional arguments:
  COMMAND
    append           append a message to a mailbox
    change-password  assign a new password to a user
    check            check the server health
    delete-user      delete a user
    get-user         get a user
    login            login as a user
    ping             ping the server
    save-args        save connection arguments to config file
    set-user         add or overwrite a user

options:
  -h, --help         show this help message and exit
  --version          show program's version number and exit
  --config PATH      connection info config file
  --host HOST        server host
  --port PORT        server port
  --path PATH        server socket file
  --token-file PATH  auth token file

tls options:
  --cert FILE        client certificate
  --key FILE         client private key
  --cafile FILE      CA cert file
  --capath PATH      CA cert path
  --no-verify-cert   disable TLS certificate verification
```

Examples:

```bash
# List all configured addresses
pymap-admin list-users

# Add a new mailbox for address 'test@example.com'
pymap-admin set-user test@example.com

# Add an alias from 'alias@example.com' to 'test@example.com'
pymap-admin set-user alias@example.com --no-password \
    --param 'alias=test@example.com

# Add an alias for all 'other.com' addresses, e.g. 'foo@other.com' would
# alias to 'test+foo@example.com'
pymap-admin set-user other.com --no-password \
    --param 'alias=test+{localpart}@example.com'

# Change the password for address 'test@example.com' without
# overwriting other metadata
pymap-admin change-password test@example.com

# Get the raw user configuration for 'test@example.com'
pymap-admin get-user test@example.com

# Delete the configuration for 'test@example.com'
pymap-admin delete-user test@example.com
```

[1]: https://docs.docker.com/compose/reference/
