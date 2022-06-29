#!/bin/bash

source ./globals.sh

FILE=$1

echo "Uploading $FILE..."
aws s3 cp "$FILE" "s3://$S3_BUCKET"
