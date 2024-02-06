#!/bin/bash

# Call the script to generate logs
/generate_log.sh &

# Include any other commands you need to run
# For example, starting a service, etc.

# Start New Relic Infrastructure agent in the background
#/newrelic-infra &

# Start Java application
java -javaagent:/newrelic/newrelic.jar -jar /app/hw-java-app.jar

tail -f /dev/null


