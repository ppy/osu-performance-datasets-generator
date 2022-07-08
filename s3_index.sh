#!/bin/bash

source ./globals.sh

files_list=$(AWS_ACCESS_KEY_ID="$DUMPS_UPLOAD_AWS_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$DUMPS_UPLOAD_AWS_SECRET_ACCESS_KEY" aws s3 ls "s3://$DUMPS_UPLOAD_S3_BUCKET" --endpoint="$DUMPS_UPLOAD_S3_ENDPOINT")

cat >index.html <<EOL
<html>
<head><title>Index of /</title></head>
<body bgcolor="white">
<h1>Index of /</h1><hr><pre><a href="../">../</a>
EOL

echo "$files_list" | while read -r line
do
  if [ -n "$line" ]; then
    file=$(echo "$line" | awk '{print $4}')
    if [ "$file" != "index.html" ]; then
      echo "<a href='$file'>"$file"</a>" >> index.html
    fi
  fi
done

cat >>index.html <<EOL
</pre><hr></body>
</html>
EOL
