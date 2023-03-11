#!/bin/bash

# AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq ".Account" | sed 's/"//g')
# REGION="eu-west-1"
# REPOSITORY_NAME="geoipdb"

IMAGE_NAME="geoip"

# Build the image
echo "-> Building the image"
docker build -t $IMAGE_NAME .

# Tag the image for pushing to ECR
echo "-> Tagging the image"
docker tag "$(docker images -q $IMAGE_NAME)" "$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:latest"

# Authenticate docker with ECR
echo "-> Authenticating docker with ECR"
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"

# Push the image to ECR
echo "-> Pushing the image to ECR"
docker push "$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:latest"

# If I try output this to $GITHUB_OUTPUT directly, it doesn't work, so make a copy first.
# imageUri="$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:latest"
imageUri="sharks.dkr.ecr.badgers.amazonaws.com/superplace:latest"

echo "image-uri=$imageUri" >> $GITHUB_OUTPUT
