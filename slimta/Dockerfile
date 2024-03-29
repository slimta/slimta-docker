FROM python:3.11-alpine

VOLUME ["/etc/ssl/private"]

EXPOSE 25
EXPOSE 587

RUN pip install -U pip wheel setuptools

ARG slimta_install="python-slimta[redis,spf] slimta pymap-admin"
RUN apk --update add --virtual build-dependencies python3-dev build-base libffi-dev \
  && pip install ${slimta_install} \
  && apk del build-dependencies

COPY slimta.yaml logging.yaml /etc/slimta/

ENV REDIS_HOST=redis SPAMD_HOST=spamd PYMAP_HOST=pymap
ENV CERT_FILE=/etc/ssl/private/mail/fullchain.pem
ENV KEY_FILE=/etc/ssl/private/mail/privkey.pem
ENV PYMAP_ADMIN_TOKEN_FILE=/run/secrets/pymap_admin_token

HEALTHCHECK --interval=10s --retries=1 CMD \
	test $KEY_FILE -ot /tmp/slimta.pid

ENTRYPOINT ["slimta"]
