role=$(aws iam list-roles | jq -r '.Roles[] | select(.RoleName == "geoip-lambda-ex") | .RoleName')

# If role does not exist, create it
if [ -z "$role" ]; then
  echo "Creating IAM role..."
  aws iam create-role \
    --role-name geoip-lambda-ex \
    --assume-role-policy-document file://.github/actions/04-create-iam-role/trust-policy.json
else
  echo "IAM Role \"geoip-lambda-ex\" already exists"
fi
