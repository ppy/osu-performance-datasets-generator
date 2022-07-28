#!/bin/bash
# Executes the monthly dump of datasets for osu-performance development purposes.

set -e

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

./s3_index.sh
./s3_upload.sh index.html
./s3_purge_cache_file.sh index.html

if [[ $(ls -1 ./work | wc -l) != "0" ]]; then
  for f in ./work/*; do
    ./s3_upload.sh "$f"
  done
fi

./s3_index.sh
./s3_upload.sh index.html
./s3_purge_cache_file.sh index.html
