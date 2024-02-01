# Base Image with JDK
FROM eclipse-temurin:17-jdk-jammy as base

WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:resolve
COPY src ./src

# Build Stage
FROM base as build
RUN ./mvnw package

# Start with New Relic Infrastructure base image
FROM newrelic/infrastructure:latest

# Install JDK/JRE for the Java application
RUN apt-get update && apt-get install -y openjdk-17-jre-headless

# Add Unzip utility
RUN apt-get install -y unzip

# Download New Relic Java APM Agent
RUN curl -O https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip
RUN unzip newrelic-java.zip && rm newrelic-java.zip

# Set Environment Variables for New Relic
ENV NEW_RELIC_APP_NAME="HW_JAVA_APP-8136-LOGS-INFRA"
ENV NEW_RELIC_LICENSE_KEY="xxx"
#ENV NEW_RELIC_LOG_FILE_NAME="STDOUT"

# Copy New Relic Infrastructure configuration
COPY newrelic-infra.yml /etc/newrelic-infra.yml
COPY newrelic.yml /etc/newrelic.yml
COPY logging.yml /etc/logging.yml

# Copy Application Jar
COPY --from=build /app/target/hello-world-app-1.0-SNAPSHOT-jar-with-dependencies.jar /app/hw-java-app.jar

# Expose Application Port
EXPOSE 8080

# Custom script to run both New Relic Infrastructure agent and Java application
COPY start.sh /start.sh
RUN chmod +x /start.sh
COPY generate_log.sh /generate_log.sh
RUN chmod +x /generate_log.sh
COPY logFile.log /logFile.log
COPY logFile1.log /logFile1.log

CMD ["/start.sh"]