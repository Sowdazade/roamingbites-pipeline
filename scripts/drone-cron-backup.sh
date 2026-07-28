#!/bin/bash
PGPASSWORD=$DB_PASSWORD pg_dump -h postgres -U roaming -d roamingbites > /tmp/backup.sql
mc alias set minio http://minio:9000 $MINIO_ACCESS_KEY $MINIO_SECRET_KEY
mc cp /tmp/backup.sql minio/backups/roamingbites_$(date +%Y%m%d_%H%M%S).sql
