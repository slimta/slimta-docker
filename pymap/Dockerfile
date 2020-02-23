FROM python:3.8

VOLUME ["/etc/ssl/private"]

EXPOSE 143
EXPOSE 9090

RUN pip install -U pip wheel setuptools typing-extensions

ARG pymap_install="pymap[redis,admin,sieve] hiredis passlib"
RUN pip install -U ${pymap_install}

COPY pymap.args /etc

ENV PYMAP_SELECT=1
ENV CERT_FILE=/etc/ssl/private/local/fullchain.pem
ENV KEY_FILE=/etc/ssl/private/local/privkey.pem

ENTRYPOINT ["pymap", "@/etc/pymap.args"]
