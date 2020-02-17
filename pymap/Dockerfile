FROM python:3.8

EXPOSE 143
EXPOSE 9090

ARG pymap_install="pymap[redis,grpc,sieve] hiredis passlib"
ARG pymap_select=1

RUN pip install -U pip wheel setuptools typing-extensions \
	${pymap_install}

ENV PYMAP_SELECT=${pymap_select}
COPY pymap.args /etc

ENTRYPOINT ["pymap", "@/etc/pymap.args"]
