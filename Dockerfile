FROM openjdk:11-jre-slim

RUN groupadd --gid 1000 java \
  && useradd --uid 1000 --gid java --shell /bin/bash --create-home java
USER java
VOLUME /tmp
WORKDIR /app
COPY --chown=java:java ./target/*.jar /app/
# To reduce Tomcat startup time we added a system property pointing to "/dev/urandom" as a source of entropy.
CMD ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app/*.jar"]