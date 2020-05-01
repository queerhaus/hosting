#!/bin/sh
#set -eux
current_date=$(date +%Y-%m-%d_%H_%M_%S)

# mastodon hometown
# https://docs.joinmastodon.org/admin/backups/
mkdir -p /opt/queerhaus/backup/hometown/$current_date
docker exec -u postgres queerhaus_town-db_1 pg_dumpall -c > /opt/queerhaus/backup/hometown/$current_date/town_dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
rsync -a --delete /opt/queerhaus/data/hometown/public/ /opt/queerhaus/backup/hometown/$current_date/public/

# codimd
mkdir -p /opt/queerhaus/backup/codi/$current_date
docker exec -u postgres queerhaus_codi-db_1 pg_dumpall -U codimd -c > /opt/queerhaus/backup/codi/$current_date/codi_dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
rsync -a --delete /opt/queerhaus/data/codi/uploads/ /opt/queerhaus/backup/codi/$current_date/uploads/

# Restore backups like this
# cat codi_dump.sql | docker exec -i queerhaus_codi-db_1 psql -U codimd
# cat town_dump.sql | docker exec -i queerhaus_town-db_1 psql -U postgres
