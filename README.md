# GEOIP lookup service

## Notes

Rather than upload the DB to S3 and read from that at application startup:

1. Create a [lambda container image](https://docs.aws.amazon.com/lambda/latest/dg/images-create.html)
2. Upon new DB release, builds the image which has the DB baked in and push that image to ECR.
3. Deploy the image to lambda to be run serverless.

## Things to note for final README
- ECR repository needs to already exist for this workflow to succeed
