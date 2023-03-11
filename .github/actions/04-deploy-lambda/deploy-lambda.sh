FUNCTION_NAME="geoip"
IAM_ROLE_NAME="lambda-execution"
IAM_ROLE_ARN="arn:aws:iam::$AWS_ACCOUNT_ID:role/$IAM_ROLE_NAME"

echo "Deploying Lambda function $FUNCTION_NAME"
echo "AWS Account ID: $AWS_ACCOUNT_ID"

# aws lambda create-function \
# 	--region $REGION \
# 	--function-name $FUNCTION_NAME \
#     --package-type Image  \
#     --code ImageUri=<ECR Image URI>   \
#     --role $IAM_ROLE_ARN
