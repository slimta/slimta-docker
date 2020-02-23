FROM python:3.8

VOLUME ["/etc/ssl/private"]

ARG dehydrated_url="https://raw.githubusercontent.com/dehydrated-io/dehydrated/307eaadddfd49aeafda6984f11e6731329372cd5/dehydrated"
RUN curl -o /usr/local/bin/dehydrated ${dehydrated_url}
RUN chmod +x /usr/local/bin/dehydrated

ARG lexicon_hook_url="https://raw.githubusercontent.com/AnalogJ/lexicon/bc1190d8f4dd12d024ee5f4975dd3175dbf215c6/examples/dehydrated.default.sh"
RUN curl -o /usr/local/bin/lexicon-hook.sh ${lexicon_hook_url}
RUN chmod +x /usr/local/bin/lexicon-hook.sh

RUN dehydrated --register --accept-terms

ARG lexicon_install="dns-lexicon"
RUN pip install -U pip wheel setuptools ${lexicon_install}

COPY run-dehydrated.sh /usr/local/bin

ENTRYPOINT ["run-dehydrated.sh"]
