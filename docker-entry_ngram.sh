#!/usr/bin/env bash
set -eu

# Use N-gram parser on MySQL to search a sentence in Japanese.
echo "Activate N-gram parser on MySQL."
echo "DEBUG: mysql -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE <<EOF"
# mysql -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE <<EOF
# ALTER TABLE Posts DROP INDEX idx_posts_message_txt;
# ALTER TABLE Posts ADD FULLTEXT INDEX idx_posts_message_txt (\`Message\`) WITH PARSER ngram COMMENT 'ngram reindex';
# EOF

# Entrypoint for mattermost-preview
# ref=https://github.com/mattermost/mattermost-docker-preview/blob/master/Dockerfile
echo "DEBUG: pwd=$PWD"
exec "$(dirname $0)/docker-entry.sh" "$@"