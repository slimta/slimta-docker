FROM python:3.8

VOLUME ["/etc/ssl/private"]

EXPOSE 25
EXPOSE 587

RUN pip install -U pip wheel setuptools

ARG slimta_install="slimta[redisstorage,spf] pymap-admin"
RUN pip install -U ${slimta_install}

ARG slimta_config
COPY ${slimta_config} /etc/slimta/slimta.yaml
COPY logging.yaml /etc/slimta/

ENV CERT_FILE=/etc/ssl/private/local/fullchain.pem
ENV KEY_FILE=/etc/ssl/private/local/privkey.pem

ENTRYPOINT ["slimta", "--no-daemon"]
