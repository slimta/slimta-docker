FROM python:3.8-alpine

VOLUME ["/var/lib/dehydrated", "/etc/ssl/private"]

RUN apk add --no-cache bash curl openssl dateutils

ARG dehydrated_url="https://raw.githubusercontent.com/dehydrated-io/dehydrated/307eaadddfd49aeafda6984f11e6731329372cd5/dehydrated"
RUN curl -o /usr/local/bin/dehydrated ${dehydrated_url}
RUN chmod +x /usr/local/bin/dehydrated

ARG lexicon_hook_url="https://raw.githubusercontent.com/AnalogJ/lexicon/bc1190d8f4dd12d024ee5f4975dd3175dbf215c6/examples/dehydrated.default.sh"
RUN curl -o /usr/local/bin/lexicon-hook.sh ${lexicon_hook_url}
RUN chmod +x /usr/local/bin/lexicon-hook.sh

RUN pip install -U pip wheel setuptools

ARG lexicon_install="dns-lexicon"
RUN apk --update add --virtual build-dependencies python-dev build-base libffi-dev openssl-dev \
  && pip install ${lexicon_install} \
  && apk del build-dependencies

RUN mkdir -p /etc/dehydrated

COPY config /etc/dehydrated
COPY register.sh /usr/local/bin
COPY run-dehydrated.sh /usr/local/bin

ENV LEXICON_ENV=/run/secrets/lexicon_env

ENTRYPOINT ["run-dehydrated.sh"]
