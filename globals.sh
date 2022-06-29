#!/bin/bash

set -e

DATABASE_HOST=db-delayed
DATABASE_USER=performance-export

OUTPUT_PATH=/var/www/html/

DATE=$(date +"%Y_%m_%d")
