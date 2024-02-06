#!/bin/bash

# Path to the log files
LOG_FILE="logFile.log"
LOG_FILE1="logFile1.log"

# Function to generate a log entry
generate_log_entry() {
    # Generate a random number between 0 and 1
    local random_choice=$((RANDOM % 2))

    # Conditional addition of "aws" to the log entry
    if [ "$random_choice" -eq 1 ]; then
        echo "$(date) - Sample log entry AWS"
    else
        echo "{\"event\": \"annual summit\", \"location\": \"Mountain View\", \"year\": 2022, \"message\": {\"title\": \"Welcome to the Summit\", \"content\": \"We are excited to have you join us this year for a series of engaging talks and workshops.\"}}"
    fi
}

# Infinite loop to generate logs
while true
do
    # Generate a new log entry
    log_entry=$(generate_log_entry)

    # Append to logFile.log
    echo "$log_entry" >> /dev/stdout

    # Append to logFile1.log if it contains 'aws'
    if [[ "$log_entry" == *"aws"* ]]; then
        echo "$log_entry" /dev/stdout #>> $LOG_FILE1
    fi

    # Wait for a few seconds before generating the next log entry
    sleep 5  # Adjust this value to control the frequency
done
