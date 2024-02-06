#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
#
#  mvn clean package
#  mvn -Dmaven.plugin.validation=VERBOSE clean package
#  
#  sudo docker build . -t hw-java-app-8136:v1
#
#  docker run -d -p 8136:8080 hw-java-app-8136:v1  
#
#  http://localhost:8136/ 
#
#  curl -X GET http://localhost:8136/api/hello  
#
# .curl -X GET http://localhost:8136/api/call-api
#
#  curl -X GET http://localhost:8136/api/hw 

FROM eclipse-temurin:17-jdk-jammy as base

WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:resolve
COPY src ./src

FROM base as build
RUN ./mvnw package

# Create Clean Image
FROM eclipse-temurin:17-jre-jammy as production

# Add Unzip utility
RUN apt-get update
RUN apt-get install unzip

# Download New Relic Java APM Agent
RUN curl -O https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip
RUN unzip newrelic-java.zip 
RUN rm newrelic-java.zip

#ENV NEW_RELIC_APP_NAME="HW_JAVA_APP-8136 "
#ENV NEW_RELIC_LICENSE_KEY="xxx"
#ENV NEW_RELIC_LOG_FILE_NAME="STDOUT"

EXPOSE 8080
COPY --from=build /app/target/hello-world-app-1.0-SNAPSHOT-jar-with-dependencies.jar /app/hw-java-app.jar
#CMD ["java", "-javaagent:/newrelic/newrelic.jar", "-jar", "/app/hw-java-app.jar"]

# Custom script to run both New Relic Infrastructure agent and Java application
COPY newrelic.yml /newrelic/newrelic.yml
COPY start.sh /start.sh
RUN chmod +x /start.sh
COPY generate_log.sh /generate_log.sh
RUN chmod +x /generate_log.sh
COPY logFile.log /logFile.log
COPY logFile1.log /logFile1.log

CMD ["/start.sh"]