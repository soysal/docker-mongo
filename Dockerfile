FROM mongo:3

MAINTAINER Ergin Soysal <esoysal@gmail.com>

ENV MONGO_USER joe
ENV MONGO_PASS secret
ENV MONGO_DB admin

ADD run.sh /run.sh

CMD "/run.sh"
