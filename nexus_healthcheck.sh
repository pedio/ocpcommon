#!/bin/bash

# Run a curl against the Nexuss instance installed in a Dockerfile
# to do a basic health check

set -x

CURL_MAX_TIME=15
ATTEMPTS=25
SLEEP_TIME=20

for ATTEMPT in $(seq ${ATTEMPTS}); do
    echo "Attempt ${ATTEMPT} of ${ATTEMPTS}"
    echo "Curling against the Nexus server"
    echo "Should expect a 200 within ${CURL_MAX_TIME} seconds"
    STATUS_CODE=$(curl -sL -w "%{http_code}" localhost:8081/nexus -o /dev/null \
        --max-time ${CURL_MAX_TIME})

    if [[ "$STATUS_CODE" == "200" ]]; then
        echo "Nexus has come up and ready to use after ${ATTEMPT} of ${ATTEMPTS} attempts"
        exit 0
    else
        echo "Nexus did not return a correct status code yet"
        echo "Returned: $STATUS_CODE"
        sleep ${SLEEP_TIME}
    fi
done

echo "Nexus still hasn't returned a 200 status code ${ATTEMPTS} attempts"
exit 1
