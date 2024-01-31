#!/bin/bash

echo "Update the Grafana organization..."

for x in {1..60}
do
  curl -s -f -X PUT -H "Content-Type: application/json" \
    -d "{\"name\":\"${GRAFANA_ORGANIZATION}\"}" https://${GRAFANA_AUTH}@${GRAFANA_FQDN}/api/orgs/1

  if [ $? -eq 0 ]; then
    exit 0
  fi

  sleep 5
done

echo "Failed to update the Grafana organization"
exit 1
