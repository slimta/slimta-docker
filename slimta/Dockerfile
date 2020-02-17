FROM python:3.8

EXPOSE 1025
EXPOSE 587
EXPOSE 25
EXPOSE 1587

ARG slimta_install="slimta[redisstorage,spf]"
ARG slimta_config

RUN pip install -U pip wheel setuptools \
	${slimta_install}

COPY ${slimta_config} /etc/slimta/slimta.yaml
COPY logging.yaml /etc/slimta/

ENTRYPOINT ["slimta", "--no-daemon"]
