FROM python:3.8-alpine

VOLUME ["/etc/ssl/private"]

EXPOSE 143
EXPOSE 9090

RUN pip install -U pip wheel setuptools typing-extensions

ARG pymap_install="pymap[redis,admin,sieve] hiredis passlib pid"
RUN apk --update add --virtual build-dependencies python-dev build-base \
  && pip install ${pymap_install} \
  && apk del build-dependencies

COPY pymap.args /etc

ENV PYMAP_SELECT=1
ENV CERT_FILE=/etc/ssl/private/local/fullchain.pem
ENV KEY_FILE=/etc/ssl/private/local/privkey.pem

HEALTHCHECK --interval=10s --retries=1 CMD \
	test $KEY_FILE -ot /tmp/pymap.pid

ENTRYPOINT ["pymap", "@/etc/pymap.args"]
