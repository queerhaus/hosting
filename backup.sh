#!/bin/sh

# mastodon hometown
# https://docs.joinmastodon.org/admin/backups/
docker exec -u postgres queerhaus_town-db_1 pg_dumpall -c > /opt/queerhaus/data/backups/town_dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

# codimd
docker exec -u postgres queerhaus_codi-db_1 pg_dumpall -U codimd -c > /opt/queerhaus/data/backups/codi_dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

# Restore backups like this
# cat codi_dump.sql | docker exec -i queerhaus_codi-db_1 psql -U codimd
# cat town_dump.sql | docker exec -i queerhaus_town-db_1 psql -U postgres