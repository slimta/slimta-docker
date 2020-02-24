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

[1]: https://docs.docker.com/compose/reference/
