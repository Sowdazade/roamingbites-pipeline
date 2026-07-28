#!/bin/bash
set -e

echo "Setting Replication on Primary..."

COMPOSE_FILE="/home/roamingbites/db/docker-compose.yml"

docker compose -f "$COMPOSE_FILE" exec -u postgres postgres_primary bash -c "
set -e

echo 'Running SQL setup...'

psql -v ON_ERROR_STOP=1 --username \"\$POSTGRES_USER\" --dbname \"\$POSTGRES_DB\" <<-EOSQL

CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'ReplicaPass123';

GRANT ALL PRIVILEGES ON DATABASE \"\$POSTGRES_DB\" TO replicator;

SELECT pg_create_physical_replication_slot('replica_slot');

CREATE TABLE IF NOT EXISTS trucks (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cuisine VARCHAR(50),
    lat FLOAT,
    lng FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO trucks (name, cuisine, lat, lng) VALUES
('Taco Loco', 'Mexican', 40.7128, -74.0060),
('Burger Bus', 'American', 40.7138, -74.0070),
('Sushi on Wheels', 'Japanese', 40.7148, -74.0080),
('Pizza Truck', 'Italian', 40.7158, -74.0090),
('Falafel Fan', 'Middle Eastern', 40.7168, -74.0100);

EOSQL

echo 'Updating pg_hba.conf...'

PGDATA_PATH=\$(psql -U \"\$POSTGRES_USER\" -d \"\$POSTGRES_DB\" -t -c \"SHOW data_directory;\" | xargs)
PG_HBA=\"\$PGDATA_PATH/pg_hba.conf\"

cat >> \"\$PG_HBA\" << 'EOF'
host    replication     replicator      0.0.0.0/0               md5
host    all             all             0.0.0.0/0               md5
EOF

psql -U \"\$POSTGRES_USER\" -d \"\$POSTGRES_DB\" -c \"SELECT pg_reload_conf();\"

echo 'Setup finished successfully.'
"

echo "Done"
