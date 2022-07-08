#!/bin/bash
# Dump .osu files from all ranked/approved/qualified/loved beatmapsets.

source ./globals.sh

cd work
output_folder="${DATE}_osu_files"

mkdir -p ${output_folder}

for i in $( mysql osu -sN -h "${DATABASE_HOST}" -u "${DATABASE_USER}" "${DATABASE_PASSWORD}" -e "select beatmap_id from osu_beatmaps WHERE approved > 0 AND deleted_at IS NULL" ); do
    echo "Downloading ${i}..."
    AWS_ACCESS_KEY_ID="$OSU_DOWNLOAD_AWS_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$OSU_DOWNLOAD_AWS_SECRET_ACCESS_KEY" aws s3 cp "s3://$OSU_DOWNLOAD_S3_BUCKET/$i" ${output_folder}/${i}.osu --endpoint="$OSU_DOWNLOAD_S3_ENDPOINT"
done

echo
echo "Compressing.."

tar -cvjSf ${output_folder}.tar.bz2 ${output_folder}/
rm -r ${output_folder}

echo
echo "All done!"
echo
