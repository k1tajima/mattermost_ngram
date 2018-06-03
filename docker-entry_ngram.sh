#!/usr/bin/env bash
# ref=https://github.com/mattermost/mattermost-docker-preview/blob/master/docker-entry.sh
set -eu
cd "$(dirname $0)"
echo "DEBUG: pwd=$PWD"
export PATH=$PATH:$PWD/mattermost/bin

# Run MySQL.
echo "Starting MySQL"
/entrypoint.sh mysqld &

until mysqladmin -hlocalhost -P3306 -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" processlist &> /dev/null; do
	echo "MySQL still not ready, sleeping"
	sleep 5
done

./reindex-ngram.sh &

# Run Mattermost.
echo "Starting Mattermost platform"
cd mattermost
exec ./bin/platform --config=config/config_docker.json