#!/bin/bash

# Database URL
DB_URL="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=$MAXMIND_LICENSE_KEY&suffix=tar.gz"
SHA256_URL="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=$MAXMIND_LICENSE_KEY&suffix=tar.gz.sha256"

echo "Downloading Maxmind's latest DB..."
curl -o "geoIP.tar.gz" -L "$DB_URL"

echo "Uncompressing file..."
tar xvf "geoIP.tar.gz"
