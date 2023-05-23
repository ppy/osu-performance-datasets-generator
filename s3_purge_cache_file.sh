#!/bin/bash

source ./globals.sh

FILE=$1

if [ -z "$DUMPS_UPLOAD_S3_PUBLIC_URL" ]; then
  echo "DUMPS_UPLOAD_S3_PUBLIC_URL is unset. Skipping cache purge for $FILE."
  exit 0
fi

if [ -n "$DUMPS_UPLOAD_S3_PURGE_AUTHORIZATION_KEY" ]; then
  echo "Purging $FILE from s3-nginx-proxy cache..."
  curl -X DELETE \
    -H "Authorization: $DUMPS_UPLOAD_S3_PURGE_AUTHORIZATION_KEY" \
    "$DUMPS_UPLOAD_S3_PUBLIC_URL/$FILE"
elif [ -n "$DUMPS_UPLOAD_R2_PURGE_CF_API_TOKEN" ] && [ -n "$DUMPS_UPLOAD_R2_PURGE_CF_ZONE_ID" ]; then
  echo "Purging $FILE from Cloudflare cache..."
  BODY=$(jq -n --arg url "$DUMPS_UPLOAD_S3_PUBLIC_URL/$FILE" '{ files: [$url] }')
  curl -X DELETE \
    -H "Authorization: Bearer $DUMPS_UPLOAD_R2_PURGE_CF_API_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$BODY" \
    "https://api.cloudflare.com/client/v4/zones/$DUMPS_UPLOAD_R2_PURGE_CF_ZONE_ID/purge_cache"
else
  echo "DUMPS_UPLOAD_S3_PURGE_AUTHORIZATION_KEY must be set for s3-nginx-proxy cache purging or DUMPS_UPLOAD_R2_PURGE_CF_API_TOKEN and DUMPS_UPLOAD_R2_PURGE_CF_ZONE_ID for Cloudflare cache purging. Skipping cache purge for $FILE."
  exit 0
fi
