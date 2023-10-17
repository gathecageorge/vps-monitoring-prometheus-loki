#!/bin/bash

# Start fresh every time
cp /etc/prometheus/global.yml /prometheus-config.yml

# Add custom prom remote write urls to config
if [ -s "/etc/prometheus/custom-prom.yml" ]; then
  echo "/etc/prometheus/custom-prom.yml" >> /prometheus-config.yml
fi

# Replace SERVER_LABEL_HOSTNAME in config file
sed -i "s/SERVER_LABEL_HOSTNAME/$SERVER_LABEL_HOSTNAME/" "/prometheus-config.yml"
exec "$@" --config.file=/prometheus-config.yml