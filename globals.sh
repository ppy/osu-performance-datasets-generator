#!/bin/bash

set -e

if [ -n "${DATABASE_PASSWORD}" ]; then
  DATABASE_PASSWORD="-p${DATABASE_PASSWORD}"
fi

DATE=$(TZ=UTC date +"%Y_%m_%d")
