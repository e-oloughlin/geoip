#!/bin/bash

SHA_FILENAME="geoIP.tar.gz.sha256"
ARCHIVE_FILENAME="geoIP.tar.gz"

DB_URL="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=$MAXMIND_LICENSE_KEY&suffix=tar.gz"
SHA256_URL="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=$MAXMIND_LICENSE_KEY&suffix=tar.gz.sha256"

# 1. Download SHA File from maxmind

echo "-> Downloading Maxmind's latest DB SHA..."
curl -o "$SHA_FILENAME" -L "$SHA256_URL"

IFS=' ' read -r -a ML <<< $(cat $SHA_FILENAME)

MAXMIND_SHA256="${ML[0]}"
MAXMIND_FILENAME="${ML[1]}"

IFS='.' read -r -a MAXMIND_FOLDERNAME <<< "$MAXMIND_FILENAME"

# 2. Download SHA File from S3

echo "-> Downloading S3's latest DB SHA..."
aws s3 cp s3://siorc/ip/$SHA_FILENAME "./S3_$SHA_FILENAME"

IFS=' ' read -r -a S3L <<< $(cat "S3_$SHA_FILENAME")
S3_SHA256="${S3L[0]}"

# 3. Compare SHA Files and if different, download DB and upload to S3

echo "-> Comparing maxmind to s3..."
if [ "$MAXMIND_SHA256" != "$S3_SHA256" ]; then
	echo "-> New update available. Downloading Maxmind's latest DB..."
	curl -o "$ARCHIVE_FILENAME" -L "$DB_URL"
	tar -xvf "$ARCHIVE_FILENAME"

	# Upload SHA & DB to S3
	echo "-> Uploading new SHA & DB file to S3..."
	aws s3 cp "$MAXMIND_FOLDERNAME/GeoLite2-City.mmdb" s3://siorc/ip/GeoLite2-City.mmdb
	aws s3 cp "$SHA_FILENAME" s3://siorc/ip/$SHA_FILENAME

	# Copy DB to docker folder
	echo "-> Copying new DB file to docker folder..."
	cp "$MAXMIND_FOLDERNAME/GeoLite2-City.mmdb" ./GeoLite2-City.mmdb

	echo "{database-updated}={true}" >> $GITHUB_OUTPUT
else
	echo "-> No update available."
	echo "{database-updated}={false}" >> $GITHUB_OUTPUT
fi
