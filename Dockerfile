FROM mattermost/mattermost-preview:4.10.4
LABEL maintainer="https://qiita.com/k1tajima"

ENV MATTERMOST_HOME=/mm/mattermost
ENV PATH="${PATH}:$MATTERMOST_HOME/bin"
VOLUME ["$MATTERMOST_HOME/config","$MATTERMOST_HOME/mattermost-data"]

# Install wget.
RUN apt-get -y install wget

# Set default character set to UTF8 on MySQL.
COPY my.cnf /etc/

# Store initial config
RUN mkdir $MATTERMOST_HOME/config_init && \
    cp -rp $MATTERMOST_HOME/config/* $MATTERMOST_HOME/config_init/

# Activate N-gram parser on MySQL to search a sentence in Japanese.
WORKDIR /mm
COPY docker-entry_ngram.sh .
COPY reindex-ngram.sh .
RUN chmod +x docker-entry_ngram.sh reindex-ngram.sh
ENTRYPOINT ["/mm/docker-entry_ngram.sh"]

# Do workarround for Mattermost platform in panic
COPY platform.sh $MATTERMOST_HOME/bin
RUN ln -s $MATTERMOST_HOME/bin/platform.sh /usr/local/bin/platform \
    && chmod +x $MATTERMOST_HOME/bin/platform.sh /usr/local/bin/platform

# Set Current Directory
WORKDIR $MATTERMOST_HOME