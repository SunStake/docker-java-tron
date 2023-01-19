FROM shinyay/docker-mvn-jdk8:3.6.3

WORKDIR /src


RUN yum install -y git bc gettext
RUN git clone https://github.com/tronprotocol/tron-eventquery.git

WORKDIR /src/tron-eventquery

RUN mvn package

COPY . /src/tron-eventquery/

RUN chmod +x entry.sh

ENTRYPOINT [ "./entry.sh" ]
