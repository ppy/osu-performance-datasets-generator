#!/bin/bash
# Executes the monthly dump of datasets for osu-performance development purposes.

set -e

find /var/www/html/*performance*.bz2 -depth -type f -ctime +180 -delete &> /dev/null
find /var/www/html/*files*.bz2 -depth -type f -ctime +180 -delete &> /dev/null

./dump_sample_tables.sh osu top 10000
./dump_sample_tables.sh osu random 10000
./dump_sample_tables.sh taiko top 10000
./dump_sample_tables.sh taiko random 10000
./dump_sample_tables.sh catch top 10000
./dump_sample_tables.sh catch random 10000
./dump_sample_tables.sh mania top 10000
./dump_sample_tables.sh mania random 10000

./dump_sample_tables.sh osu top 1000
./dump_sample_tables.sh taiko top 1000
./dump_sample_tables.sh catch top 1000
./dump_sample_tables.sh mania top 1000

./dump_all_osu.sh

./s3_prune.sh

for f in ./*.bz2; do
  ./s3_upload.sh *.bz2
done

./s3_index.sh
./s3_upload.sh index.html
