#!/bin/bash

SHA_FILENAME="geoIP.tar.gz.sha256"
SHA256_URL="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=$MAXMIND_LICENSE_KEY&suffix=tar.gz.sha256"

# 1. Download SHA File from maxmind

echo "-> Downloading Maxmind's latest DB SHA..."
curl -o "$SHA_FILENAME" -L "$SHA256_URL"

echo "Maxmind's latest SHA: "
cat $SHA_FILENAME

IFS=' ' read -r -a ML <<< $(cat $SHA_FILENAME)

MAXMIND_SHA256="${ML[0]}"

# 2. Download SHA File from S3

echo "-> Downloading S3's latest DB SHA..."
aws s3 cp s3://siorc/ip/$SHA_FILENAME "./S3_$SHA_FILENAME"

IFS=' ' read -r -a S3L <<< $(cat "S3_$SHA_FILENAME")
S3_SHA256="${S3L[0]}"

# 3. Compare SHA Files and if different, mark as update available
# 	 and upload new SHA file to S3

echo "-> Comparing maxmind to s3..."
if [ "$MAXMIND_SHA256" != "$S3_SHA256" ]; then
	echo "-> New update available."

	echo "-> Uploading new SHA file to S3..."
	aws s3 cp "$SHA_FILENAME" s3://siorc/ip/$SHA_FILENAME

	echo "update-available=true" >> $GITHUB_OUTPUT
	echo ":white_check_mark: Maxmind update available" >> $GITHUB_STEP_SUMMARY
else
	echo "-> No update available."
	echo "update-available=false" >> $GITHUB_OUTPUT
	echo ":x: No maxmind update available" >> $GITHUB_STEP_SUMMARY
fi
