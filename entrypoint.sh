#!/bin/bash
set -e

rm -f /reservation_api/tmp/pids/server.pid

exec "$@"
