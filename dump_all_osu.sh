#!/bin/bash
# Dump .osu files from all ranked/approved/qualified/loved beatmapsets.

source ./globals.sh

cd work
output_folder="${DATE}_osu_files"

latest_osu_files_dump=$((AWS_ACCESS_KEY_ID="$DUMPS_UPLOAD_AWS_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$DUMPS_UPLOAD_AWS_SECRET_ACCESS_KEY" aws s3 ls "s3://$DUMPS_UPLOAD_S3_BUCKET" --endpoint="$DUMPS_UPLOAD_S3_ENDPOINT" | grep "_osu_files\\.tar\\.bz2$" | tail -n 1 | awk '{print $4}') || true)
if [[ -n "$latest_osu_files_dump" ]]; then
    echo "Downloading most recent .osu files dump..."
    AWS_ACCESS_KEY_ID="$DUMPS_UPLOAD_AWS_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$DUMPS_UPLOAD_AWS_SECRET_ACCESS_KEY" aws s3 cp "s3://$DUMPS_UPLOAD_S3_BUCKET/$latest_osu_files_dump" - --endpoint="$DUMPS_UPLOAD_S3_ENDPOINT" | tar -xj
    mv "${latest_osu_files_dump%.tar.bz2}" "${output_folder}"
else
    mkdir -p "${output_folder}"
fi

cd "${output_folder}"

mysql osu -sN -h "${DATABASE_HOST}" -u "${DATABASE_USER}" "${DATABASE_PASSWORD}" -e "select beatmap_id, checksum from osu_beatmaps WHERE approved > 0 AND deleted_at IS NULL" | while read -r line; do
    arr=($line)
    id=${arr[0]}
    db_checksum=${arr[1]}
    download=0

    if [ -f "${id}.osu" ]; then
        local_checksum=$(md5sum ${id}.osu | awk '{print $1}')
        if [ "$local_checksum" != "$db_checksum" ]; then
            echo "WARNING: checksum mismatch for ${id}.osu, redownloading"
            download=1
        else
            echo "Checksum match for ${id}.osu, skipping"
        fi
    else
        download=1
        echo "${id}.osu doesn't exist, downloading"
    fi

    if [ $download -eq 1 ]; then
        AWS_ACCESS_KEY_ID="$OSU_DOWNLOAD_AWS_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$OSU_DOWNLOAD_AWS_SECRET_ACCESS_KEY" aws s3 cp "s3://$OSU_DOWNLOAD_S3_BUCKET/$id" "${id}.osu" --endpoint="$OSU_DOWNLOAD_S3_ENDPOINT"
    fi
done

echo
echo "Compressing.."

cd ..
tar -cjSf ${output_folder}.tar.bz2 ${output_folder}/
rm -r ${output_folder}

echo
echo "All done!"
echo
