#!/usr/bin/env bash
# Do workarround for Mattermost platform in panic
if [ -n "$MATTERMOST_HOME" ]; then
    work_dir="$MATTERMOST_HOME"
elif [ -d /mm/mattermost ]; then
    work_dir=/mm/mattermost
else
    work_dir="$(dirname $0)"
fi

pushd "$work_dir"
./bin/platform "$@"
popd