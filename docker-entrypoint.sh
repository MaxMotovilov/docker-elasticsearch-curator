#!/bin/bash

set -ex

# Add curator as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- curator "$@"
fi

# Step down via gosu  
if [ "$1" = 'curator' ]; then
	exec gosu curator bash -c "while true; do curator_cli --host $ELASTICSEARCH_HOST delete_indices --filter_list \"[{\\\"filtertype\\\":\\\"pattern\\\",\\\"kind\\\":\\\"prefix\\\",\\\"value\\\":\\\"logstash-\\\"},{\\\"filtertype\\\":\\\"space\\\",\\\"disk_space\\\":$GIGABYTE_LIMIT}]\"; set -e; sleep $(( 60*60*INTERVAL_IN_HOURS )); set +e; done"
fi

# As argument is not related to curator,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"
