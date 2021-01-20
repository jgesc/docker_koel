#!/bin/bash

# only run if koel:sync isn't running
for pid in $(pgrep 'koel.*sync'); do
    if [ $pid != $$ ]; then
        echo "[$(date)] : Process is already running with PID $pid"
        exit 1
    fi
done

PATH=${PATH}:/usr/local/bin
PROJECT_DIR=/opt/docker_koel
LOGFILE=/tmp/koel-sync.log

docker-compose -f ${PROJECT_DIR}/docker-compose.yml exec -T koel sudo -Eu www-data php artisan koel:sync 2>&1 > ${LOGFILE}
