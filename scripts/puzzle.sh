#!/bin/bash

#Retrieve the latest git commit hash
BUILD_TAG=`git rev-parse --short HEAD`

#Build the docker image
docker build -t 192.168.50.39:32773/puzzle:$BUILD_TAG -f applications/puzzle/Dockerfile applications/puzzle

#Push the images
docker push 192.168.50.39:32773/puzzle:$BUILD_TAG

# Create the deployment and service for the puzzle server aka puzzle
sed 's#192.168.50.39:32772/puzzle:$BUILD_TAG#192.168.50.39:32772/puzzle:'$BUILD_TAG'#' applications/puzzle/k8s/deployment.yaml | kubectl apply -f -

