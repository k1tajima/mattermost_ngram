FROM mattermost/mattermost-preview
LABEL maintainer="https://qiita.com/k1tajima"

# Set default character set to UTF8 for MySQL.
COPY ./my.cnf /etc/

# Use N-gram parser for MySQL to search a sentence in Japanese.
COPY ./ngram_reindex.sql /tmp/
RUN /bin/sh -c "mysql -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE < /tmp/ngram_reindex.sql"

# Add mount points
# VOLUME /mm/mattermost/mattermost-data /mm/mattermost/config
