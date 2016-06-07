#!/bin/bash
echo "Waiting for database connection..."
/bin/wait-for-it.sh -t 0 ${DB_HOST}:${DB_PORT}
echo "Successfully found the database connection..."
exec "$@"