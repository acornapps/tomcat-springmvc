FROM maven:3.5.0-jdk-8 AS builder

# speed up Maven JVM a bit
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"

# make source folder
WORKDIR /app

# copy other source files (keep code snapshot in image)
COPY pom.xml /app
# run packaging
COPY src /app/src
RUN mvn package -T 1C

# customize base JDK version here
FROM  tomcat:latest
MAINTAINER skyikho@acornsoft.io
COPY  --from=builder /app/target/ROOT.war /usr/local/tomcat/webapps/
EXPOSE 8080
