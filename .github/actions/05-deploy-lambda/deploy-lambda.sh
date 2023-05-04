iamRoleArn=$(aws iam get-role --role-name geoip-lambda-ex | jq -r '.Role.Arn')
imageUri=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPOSITORY_NAME:latest

function=$(aws lambda list-functions | jq -r '.Functions[] | select(.FunctionName == "geoip") | .FunctionName')

# If the function does not exist, create it
if [ -z "$function" ]; then
  aws lambda create-function \
	--region $AWS_REGION \
	--function-name geoip \
    --package-type Image  \
    --code ImageUri=$imageUri   \
    --role $iamRoleArn

  echo ":white_check_mark: Function created" >> $GITHUB_STEP_SUMMARY
else
  echo "Function already exists, updating function code..."

  aws lambda update-function-code \
    --region $AWS_REGION \
    --function-name geoip \
    --image-uri $imageUri

  echo ":white_check_mark: Function updated" >> $GITHUB_STEP_SUMMARY
fi
