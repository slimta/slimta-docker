FROM python:3.8-alpine

VOLUME ["/var/lib/dehydrated", "/etc/ssl/private"]

RUN apk add --no-cache bash curl openssl dateutils

ARG dehydrated_url="https://raw.githubusercontent.com/dehydrated-io/dehydrated/dc552c602eca94737b66e62f4c4087a4e8f251e4/dehydrated"
RUN curl -o /usr/local/bin/dehydrated ${dehydrated_url}
RUN chmod +x /usr/local/bin/dehydrated

ARG lexicon_hook_url="https://raw.githubusercontent.com/AnalogJ/lexicon/b4aae8275a479d580698fc5951ee502cb300ef6f/examples/dehydrated.default.sh"
RUN curl -o /usr/local/bin/lexicon-hook.sh ${lexicon_hook_url}
RUN chmod +x /usr/local/bin/lexicon-hook.sh

RUN pip install -U pip wheel setuptools

ARG lexicon_install="dns-lexicon"
RUN apk --update add --virtual build-dependencies python-dev build-base libffi-dev openssl-dev \
  && pip install ${lexicon_install} \
  && apk del build-dependencies

RUN mkdir -p /etc/dehydrated

COPY config /etc/dehydrated
COPY run-dehydrated.sh /usr/local/bin

ENV DOMAINS=
ENV LEXICON_ENV=/run/secrets/lexicon_env
ENV OUTDIR=/etc/ssl/private

ENTRYPOINT ["run-dehydrated.sh"]
