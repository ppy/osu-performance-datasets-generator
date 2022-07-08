#!/bin/bash

source ./globals.sh

FILE=$1

if [ -z "$DUMPS_UPLOAD_S3_PUBLIC_URL" ] || [ -z "$DUMPS_UPLOAD_S3_PURGE_AUTHORIZATION_KEY" ]; then
  echo "DUMPS_UPLOAD_S3_PUBLIC_URL or DUMPS_UPLOAD_S3_PURGE_AUTHORIZATION_KEY are unset. Skipping cache purge for $FILE."
  exit 0
fi

echo "Purging $FILE from s3-nginx-proxy cache..."
curl -X DELETE -H "Authorization: $DUMPS_UPLOAD_S3_PURGE_AUTHORIZATION_KEY" "$DUMPS_UPLOAD_S3_PUBLIC_URL/$FILE"
