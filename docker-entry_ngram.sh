#!/usr/bin/env bash
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

# Use N-gram parser on MySQL to search a keyword in Japanese.
./reindex-ngram.sh &

# Run Mattermost.
cd "$MATTERMOST_HOME"
cp -rn ./config ./mattermost-data/
MATTERMOST_CONFIG=mattermost-data/config/config_docker.json
echo "Starting Mattermost platform (config=$PWD/$MATTERMOST_CONFIG)"
exec ./bin/platform --config="$MATTERMOST_CONFIG"