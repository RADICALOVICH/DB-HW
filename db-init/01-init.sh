#!/usr/bin/env bash
set -euo pipefail

# Запускается один раз при первом старте контейнера (когда volume pgdata пуст).
# Создаёт БД для каждой задачи и наливает schema.sql + data.sql из /repo.

create_and_load() {
    local db_name=$1
    local dir=$2
    echo ">>> [$db_name] CREATE DATABASE + load $dir/{schema,data}.sql"
    psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -c "CREATE DATABASE \"$db_name\";"
    psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$db_name" -f "/repo/$dir/schema.sql"
    psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$db_name" -f "/repo/$dir/data.sql"
}

create_and_load vehicles      01-vehicles
create_and_load races         02-races
create_and_load hotels        03-hotels
create_and_load organization  04-organization
