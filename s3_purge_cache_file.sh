#!/bin/bash

source ./globals.sh

FILE=$1

if [ -z "$S3_PUBLIC_URL" ] || [ -z "$S3_PURGE_AUTHORIZATION_KEY" ]; then
  echo "S3_PUBLIC_URL or S3_PURGE_AUTHORIZATION_KEY are unset. Skipping cache purge for $FILE."
  exit 0
fi

echo "Purging $FILE from s3-nginx-proxy cache..."
curl -X DELETE -H "Authorization: $S3_PURGE_AUTHORIZATION_KEY" "$S3_PUBLIC_URL/$FILE"
