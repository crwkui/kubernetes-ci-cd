#!/bin/bash

#Retrieve the latest git commit hash
BUILD_TAG=`git rev-parse --short HEAD`

#Build the docker image
docker build -t 192.168.50.39:32772/kr8sswordz:$BUILD_TAG -f applications/kr8sswordz-pages/Dockerfile applications/kr8sswordz-pages

#Push the images
docker push 192.168.50.39:32772/kr8sswordz:$BUILD_TAG

# Create the deployment and service for the front end aka kr8sswordz
sed 's#192.168.50.39:32772/kr8sswordz:$BUILD_TAG#192.168.50.39:32772/kr8sswordz:'$BUILD_TAG'#' applications/kr8sswordz-pages/k8s/deployment.yaml | kubectl apply -f -
