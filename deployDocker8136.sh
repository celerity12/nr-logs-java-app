#!/bin/bash

# Find the container ID based on the image name
container_id=$(docker ps -qf "ancestor=hw-java-app-8136:v1")
rm -rf ./deploy.logs >> /dev/null 2>&1

# Check if the container exists
if [[ -n "$container_id" ]]; then
    # Stop the container
    docker stop "$container_id"  >> deploy.logs 2>&1
    echo "Container stopped!"

    # Delete the container
    docker rm "$container_id"  >> deploy.logs 2>&1
    echo "Container instance deleted!"

    # Delete the image
    docker rmi hw-java-app-8136:v1  >> deploy.logs 2>&1
    echo "Container Image deleted!"
fi

sleep 5

echo "Ensure the container 8136, image is deleted!"
# Prompt for confirmation
read -p "yes/no? (y/n): " answer

# Check the user's response
if [[ $answer == [Yy] ]]; then
    echo "Continuing..."
    mvn -Dmaven.plugin.validation=VERBOSE clean package >> deploy.logs 2>&1
    # Check the exit status of the previous command
    if [ $? -ne 0 ]; then
        echo "Error: The command 'mvn package' failed."
        exit 1  # Quit the script with a non-zero exit code
    fi
    echo "Success: The command 'mvn clean package' completed."

    sudo docker build . -t hw-java-app-8136:v1   >> deploy.logs 2>&1
    # Check the exit status of the previous command
    if [ $? -ne 0 ]; then
        echo "Error: The command 'docker build' failed."
        exit 1  # Quit the script with a non-zero exit code
    fi
    echo "Success: The command 'docker build' completed."

    docker run -d -p 8136:8080 hw-java-app-8136:v1  >> deploy.logs 2>&1
    # Check the exit status of the previous command
    if [ $? -ne 0 ]; then
        echo "Error: The command 'docker run' failed."
        exit 1  # Quit the script with a non-zero exit code
    fi
    echo "Success: The command 'docker run' completed."
    echo "Deployed! navigate to  http://localhost:8136/ "

else
    echo "Script execution cancelled"
fi
