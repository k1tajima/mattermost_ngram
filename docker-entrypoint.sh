#!/usr/bin/env bash
set -eu

# Use N-gram parser on MySQL to search a sentence in Japanese.
echo "Activate N-gram parser on MySQL."
echo "DEBUG: mysql -user=$MYSQL_USER -password=$MYSQL_PASSWORD $MYSQL_DATABASE <<EOF"
# mysql -user=$MYSQL_USER -password=$MYSQL_PASSWORD $MYSQL_DATABASE <<EOF
# ALTER TABLE Posts DROP INDEX idx_posts_message_txt;
# ALTER TABLE Posts ADD FULLTEXT INDEX idx_posts_message_txt (`Message`) WITH PARSER ngram COMMENT 'ngram reindex';
# EOF

exec "$@"