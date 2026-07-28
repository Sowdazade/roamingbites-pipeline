#!/bin/sh
set -e
URL=${PLUGIN_URL:-http://localhost:5000/health}
EXPECTED=${PLUGIN_EXPECTED_STATUS:-200}

echo "Checking $URL ..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [ "$STATUS" -eq "$EXPECTED" ]; then
    echo "Health check passed (status $STATUS)"
    exit 0
else
    echo "Health check failed (got $STATUS, expected $EXPECTED)"
    exit 1
fi
