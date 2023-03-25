#!/bin/bash

IMAGE_NAME="geoip"

# Build the image
echo "-> Building the image"
docker build -t $IMAGE_NAME .

# Tag the image for pushing to ECR
echo "-> Tagging the image"
docker tag "$(docker images -q $IMAGE_NAME)" "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPOSITORY_NAME:latest"

# Authenticate docker with ECR
echo "-> Authenticating docker with ECR"
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

# Push the image to ECR
echo "-> Pushing the image to ECR"
docker push "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPOSITORY_NAME:latest"
