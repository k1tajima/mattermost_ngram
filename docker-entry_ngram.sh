#!/bin/bash
# ref=https://github.com/mattermost/mattermost-docker-preview/blob/master/docker-entry.sh
set -eu
cd "$(dirname $0)"

# Run MySQL.
echo "Starting MySQL"
/entrypoint.sh mysqld &

until mysqladmin -hlocalhost -P3306 -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" processlist &> /dev/null; do
	echo "MySQL still not ready, sleeping"
	sleep 5
done

echo "Updating CA certificates"
update-ca-certificates --fresh >/dev/null

# Use N-gram parser on MySQL to search a keyword in Japanese.
/mm/reindex-ngram.sh &

# Run Mattermost.
cd "$MATTERMOST_HOME"
cp -nrp ./config_init/* ./config/
MATTERMOST_CONFIG=$PWD/config/config_docker.json
echo "Starting Mattermost (config=$MATTERMOST_CONFIG)"
exec ./bin/mattermost --config="$MATTERMOST_CONFIG"