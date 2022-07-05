#!/bin/bash

source ./globals.sh

files_list=$(aws s3 ls "s3://$S3_BUCKET" $AWSCLI_SUFFIX | grep "\\.bz2$")

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
        aws s3 rm "s3://$S3_BUCKET/$file" $AWSCLI_SUFFIX
      fi
    fi
  fi
done
