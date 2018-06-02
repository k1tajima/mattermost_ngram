FROM mattermost/mattermost-preview
LABEL maintainer="https://qiita.com/k1tajima"

# Set default character set to UTF8 on MySQL.
COPY my.cnf /etc/

# Activate N-gram parser on MySQL to search a sentence in Japanese.
COPY docker-entrypoint.sh /usr/local/bin/
# RUN ln -s usr/local/bin/docker-entrypoint.sh /
# ENTRYPOINT ["/docker-entrypoint.sh"]

# Add mount points
# VOLUME /mm/mattermost/mattermost-data /mm/mattermost/config
