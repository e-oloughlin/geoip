AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq ".Account" | sed 's/"//g')
REGION="eu-west-1"
REPOSITORY_NAME="jagggysnake"
IMAGE_ID="geoip"

# Build the image
docker build -t geoip .

# Authenticate docker with ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"

# Tag the image for pushing to ECR
docker tag "$IMAGE_ID" "$AWS_ACCOUNT_ID.dkr.ecr.region.amazonaws.com/$REPOSITORY_NAME"

# Push the image to ECR
docker push "$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME"
