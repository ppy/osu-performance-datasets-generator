#!/bin/bash

source ./globals.sh

files_list=$(aws s3 ls "s3://$S3_BUCKET")

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
