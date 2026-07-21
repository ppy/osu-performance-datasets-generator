#!/bin/bash

set -euo pipefail

if [[ -n "${SCHEDULE:-}" ]]; then
  echo "Running in cron mode with schedule: $SCHEDULE"
  echo "$SCHEDULE cd /src && /src/dump_all.sh" > /crontab
  exec supercronic /crontab
else
  exec /src/dump_all.sh
fi
