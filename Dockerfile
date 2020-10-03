FROM openjdk:8-jdk AS build

ENV JAVA_TRON_VERSION=GreatVoyage-v4.0.1

WORKDIR /src
RUN git clone -b "${JAVA_TRON_VERSION}" --depth 1 https://github.com/tronprotocol/java-tron.git

RUN cd java-tron && \
    ./gradlew build -x test

FROM openjdk:8-jdk AS build-plugin

WORKDIR /src
RUN git clone --depth 1 https://github.com/tronprotocol/event-plugin.git

RUN cd event-plugin && \
    ./gradlew build -x test

FROM openjdk:8-jre

COPY --from=build /src/java-tron/build/libs/FullNode.jar /usr/local/tron/FullNode.jar
COPY --from=build-plugin /src/event-plugin/build/plugins/ /usr/local/tron/plugins/
COPY ./configs/ /etc/tron/

COPY ./entry.sh /usr/bin/entry.sh

ENTRYPOINT [ "entry.sh" ]
