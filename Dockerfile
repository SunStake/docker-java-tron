FROM openjdk:8-jdk AS build

ENV JAVA_TRON_VERSION=GreatVoyage-v4.0.1

WORKDIR /src
RUN git clone -b "${JAVA_TRON_VERSION}" --depth 1 https://github.com/tronprotocol/java-tron.git

RUN cd java-tron && \
    ./gradlew build -x test

FROM ubuntu AS config

RUN apt-get update && \
    apt-get install -y curl && \
    mkdir /config && \
    curl https://raw.githubusercontent.com/tronprotocol/tron-deployment/master/main_net_config.conf -o /config/main_net_config.conf && \
    curl https://raw.githubusercontent.com/tronprotocol/tron-deployment/master/test_net_config.conf -o /config/test_net_config.conf

FROM openjdk:8-jre

COPY --from=build /src/java-tron/build/libs/FullNode.jar /usr/local/tron/FullNode.jar
COPY --from=config /config/ /etc/tron/

COPY ./entry.sh /usr/bin/entry.sh

ENTRYPOINT [ "entry.sh" ]
