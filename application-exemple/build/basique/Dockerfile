FROM openjdk:8-alpine

VOLUME /opt/output

COPY front-end /front-end

RUN cd /front-end && chmod u+x gradlew && ./gradlew -v && ./gradlew --console=verbose clean build

ENTRYPOINT cd /front-end && ./gradlew --console=verbose clean build && cp build/libs/*.jar /opt/output
