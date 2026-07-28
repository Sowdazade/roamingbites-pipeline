#!/bin/bash
set -e

echo "Launch Replica"

COMPOSE_FILE="/home/roamingbites/db/docker-compose.yml"

docker compose -f "$COMPOSE_FILE" exec -u postgres postgres_replica bash -c "
set -e

if [ -d \"/var/lib/postgresql/data/pgdata\" ] && [ \"\$(ls -A /var/lib/postgresql/data/pgdata 2>/dev/null)\" ]; then
    echo \"Deleting existing data...\"
    rm -rf /var/lib/postgresql/data/pgdata/*
else
    echo \"No existing data found or directory doesn't exist. Creating...\"
    mkdir -p /var/lib/postgresql/data/pgdata
fi

export PGPASSWORD=ReplicaPass123

echo \"Receiving data from primary...\"

pg_basebackup -h postgres_primary -U replicator -D /var/lib/postgresql/data/pgdata -Fp -Xs -P -R -v

chown -R postgres:postgres /var/lib/postgresql/data/pgdata
chmod 700 /var/lib/postgresql/data/pgdata

echo 'Setup finished successfully.'
"

echo "Done"

