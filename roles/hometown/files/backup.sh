#!/bin/sh
#set -eux
current_date=$(date +%Y-%m-%d_%H_%M_%S)
data_volume="/mnt/HC_Volume_5261419/queerhaus/"

# create backup folder
mkdir -p $data_volume/backup/hometown/$current_date

# https://docs.joinmastodon.org/admin/backups/
docker exec -u postgres queerhaus_town-db_1 pg_dumpall -c \
	> $data_volume/backup/hometown/$current_date/town_$current_date.sql

# also backup the files
rsync -a $data_volume/data/hometown/ $data_volume/backup/hometown/$current_date/

# Restore database like this
# cat town_dump.sql | docker exec -i queerhaus_town-db_1 psql -U postgres
