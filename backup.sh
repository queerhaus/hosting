#!/bin/sh

# mastodon hometown
# https://docs.joinmastodon.org/admin/backups/
docker exec -u postgres queerhaus_town-db_1 pg_dumpall -c > /opt/queerhaus/data/backups/hometown/town_dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
rsync -a --delete /opt/queerhaus/data/hometown/public/ /opt/queerhaus/data/backups/hometown/public/

# codimd
docker exec -u postgres queerhaus_codi-db_1 pg_dumpall -U codimd -c > /opt/queerhaus/data/backups/codi/codi_dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
rsync -a --delete /opt/queerhaus/data/codi/uploads/ /opt/queerhaus/data/backups/codi/uploads/

# Restore backups like this
# cat codi_dump.sql | docker exec -i queerhaus_codi-db_1 psql -U codimd
# cat town_dump.sql | docker exec -i queerhaus_town-db_1 psql -U postgres
