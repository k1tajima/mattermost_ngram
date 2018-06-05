FROM mattermost/mattermost-preview
LABEL maintainer="https://qiita.com/k1tajima"

ENV MATTERMOST_HOME=/mm/mattermost
VOLUME ["$MATTERMOST_HOME/mattermost-data", "$MATTERMOST_HOME/config"]

# Install wget.
RUN apt-get -y install wget

# Set default character set to UTF8 on MySQL.
COPY my.cnf /etc/

# Set PATH for Mattermost.
COPY profile_mattermost.sh /etc/profile.d
RUN chmod +x /etc/profile.d/profile_mattermost.sh

# Activate N-gram parser on MySQL to search a sentence in Japanese.
WORKDIR /mm
COPY docker-entry_ngram.sh .
COPY reindex-ngram.sh .
RUN chmod +x docker-entry_ngram.sh reindex-ngram.sh

ENTRYPOINT ["./docker-entry_ngram.sh"]