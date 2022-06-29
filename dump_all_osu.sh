#!/bin/bash
# Dump .osu files from all ranked/approved/qualified/loved beatmapsets.

DATABASE_HOST=db-delayed
DATABASE_USER=performance-export

OUTPUT_PATH=/var/www/html/

date=$(date +"%Y_%m_%d")
output_folder="${date}_osu_files"

mkdir -p ${output_folder}

for i in $( mysql osu -sN -h "${DATABASE_HOST}" -u "${DATABASE_USER}" -e "select beatmap_id from osu_beatmaps WHERE approved > 0 AND deleted_at IS NULL" ); do
    echo "Downloading ${i}..."
    curl -s https://osu.ppy.sh/osu/${i} -o ${output_folder}/${i}.osu
done

echo
echo "Compressing.."

tar -cvjSf ${output_folder}.tar.bz2 ${output_folder}/
# rm -r ${output_folder}

mv ${output_folder}.tar.bz2 ${OUTPUT_PATH}/

rm -r ${output_folder}

echo
echo "All done!"
echo
