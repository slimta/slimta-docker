FROM python:3.8-alpine

VOLUME ["/etc/ssl/private"]

EXPOSE 25
EXPOSE 587

RUN pip install -U pip wheel setuptools

ARG slimta_install="slimta[redisstorage,spf] pymap-admin"
RUN apk --update add --virtual build-dependencies python-dev build-base libffi-dev \
  && pip install ${slimta_install} \
  && apk del build-dependencies

ARG slimta_config
COPY ${slimta_config} /etc/slimta/slimta.yaml
COPY logging.yaml /etc/slimta/

ENV CERT_FILE=/etc/ssl/private/local/fullchain.pem
ENV KEY_FILE=/etc/ssl/private/local/privkey.pem

HEALTHCHECK --interval=10s --retries=1 CMD \
	test $KEY_FILE -ot /tmp/slimta.pid

ENTRYPOINT ["slimta", "--no-daemon"]
