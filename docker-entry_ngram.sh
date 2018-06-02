#!/usr/bin/env bash
# ref=https://github.com/mattermost/mattermost-docker-preview/blob/master/docker-entry.sh
set -u
cd "$(dirname $0)"
echo "DEBUG: pwd=$PWD"

# Run MySQL.
echo "Starting MySQL"
/entrypoint.sh mysqld &

until mysqladmin -hlocalhost -P3306 -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" processlist &> /dev/null; do
	echo "MySQL still not ready, sleeping"
	sleep 5
done

# Run Mattermost.
echo "Starting Mattermost platform"
cd mattermost
./bin/platform --config=config/config_docker.json &

# Wait for Mattermost to get ready.
wget -q -t 10 http://localhost:8065
echo "Mattermost is ready."

# Use N-gram parser on MySQL to search a sentence in Japanese.
echo "Activate N-gram parser on MySQL."
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" $MYSQL_DATABASE <<EOF
ALTER TABLE Posts DROP INDEX idx_posts_message_txt;
ALTER TABLE Posts ADD FULLTEXT INDEX idx_posts_message_txt (\`Message\`) WITH PARSER ngram COMMENT 'ngram reindex';
EOF

jobs
fg %2
# exec "$@"