#!/bin/sh
#set -eux
current_date=$(date +%Y-%m-%d_%H_%M_%S)

mkdir -p /opt/queerhaus/backup/codi/$current_date

# codimd
docker exec -u postgres queerhaus_codi-db_1 pg_dumpall -U codimd -c \
	> /opt/queerhaus/backup/codi/$current_date/codi_dump_$current_date.sql
rsync -a --delete /opt/queerhaus/data/codi/uploads/ \
	/opt/queerhaus/backup/codi/$current_date/uploads/

# Restore backups like this
# cat codi_dump.sql | docker exec -i queerhaus_codi-db_1 psql -U codimd
