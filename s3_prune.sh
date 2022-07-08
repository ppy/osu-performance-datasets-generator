#!/bin/bash

source ./globals.sh

files_list=$((AWS_ACCESS_KEY_ID="$DUMPS_UPLOAD_AWS_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$DUMPS_UPLOAD_AWS_SECRET_ACCESS_KEY" aws s3 ls "s3://$DUMPS_UPLOAD_S3_BUCKET" --endpoint="$DUMPS_UPLOAD_S3_ENDPOINT" | grep "\\.bz2$") || true)

get_months() {
  echo $(( $(date -d "$1" +%Y) * 12 + $(date -d "$1" +%m) - 1 ))
}

current_months=$(get_months $(date +"%Y-%m-%d"))

echo "$files_list" | while read -r line; do
  if [ -n "$line" ]; then
    file=$(echo "$line" | awk '{print $4}')
    date=$(echo "${file:0:10}" | sed 's/_/-/g')
    if date -d "${date}" >/dev/null 2>&1; then
      months=$(get_months $date)
      if [ $months -le $(($current_months - 6)) ]; then
        echo "Deleting $file"
        AWS_ACCESS_KEY_ID="$DUMPS_UPLOAD_AWS_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$DUMPS_UPLOAD_AWS_SECRET_ACCESS_KEY" aws s3 rm "s3://$DUMPS_UPLOAD_S3_BUCKET/$file" --endpoint=$DUMPS_UPLOAD_S3_ENDPOINT
      fi
    fi
  fi
done
