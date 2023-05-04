#!/bin/bash

SHA_FILENAME="geoIP.tar.gz.sha256"
ARCHIVE_FILENAME="geoIP.tar.gz"
DB_FILE_NAME="GeoLite2-City.mmdb"

DB_URL="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=$MAXMIND_LICENSE_KEY&suffix=tar.gz"

# Download SHA File from S3
echo "-> Downloading S3's latest DB SHA..."
aws s3 cp s3://siorc/ip/$SHA_FILENAME "./$SHA_FILENAME"

# Get the maxmind filename from the sha file
IFS=' ' read -r -a MAXMIND_FILE <<< $(cat $SHA_FILENAME)
MAXMIND_FILENAME="${MAXMIND_FILE[1]}"

# Get the maxmind foldername from the filename (remove the .tar.gz)
IFS='.' read -r -a MAXMIND_FN <<< "$MAXMIND_FILENAME"
MAXMIND_FOLDERNAME="${MAXMIND_FN[0]}"

# Download the maxmind DB archive
echo "-> Downloading Maxminds's latest DB archive..."
curl -o "$ARCHIVE_FILENAME" -L "$DB_URL"

# Extract the archive
echo "-> Extracting archive..."
tar -xvf "$ARCHIVE_FILENAME"

mv "$MAXMIND_FOLDERNAME/$DB_FILE_NAME" ./

# Define step outputs

# The key which is used to cache the DB file under
echo "cache-key=$MAXMIND_FOLDERNAME" >> $GITHUB_OUTPUT

# The path to the DB file, in this case just the file name
# as it is in the root of the repo
echo "file-name=$DB_FILE_NAME" >> $GITHUB_OUTPUT
