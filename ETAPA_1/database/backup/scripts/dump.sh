#!/bin/bash

set -e

echo "Job iniciado: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/tmp/bkp/$PREFIX-$DATE.sql"

pg_dump -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -f "$FILE" -d "$PGDB" -Fc

if [ ! -z "$DELETE_OLDER_THAN" ]; then
	echo "Excluindo backups antigos: $DELETE_OLDER_THAN"
	find /tmp/bkp/*.sql -mmin "+$DELETE_OLDER_THAN" -exec rm {} \;
fi



echo "Job finalizado: $(date)"