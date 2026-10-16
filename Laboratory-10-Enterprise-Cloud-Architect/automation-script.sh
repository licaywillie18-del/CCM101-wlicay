#!/bin/bash
BACKUP_DIR="/home/ubuntu/ccm101-mission10/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p "$BACKUP_DIR"

docker exec ccm101_mariadb mariadb-dump -u wpuser -pMariapassword@321 wordpress > "$BACKUP_DIR/db_backup_$TIMESTAMP.sql"
docker exec ccm101_wordpress tar -czf - /var/www/html > "$BACKUP_DIR/wp_backup_$TIMESTAMP.tar.gz" 2>/dev/null || true

echo "Backup completed successfully:$TIMESTAMP"
