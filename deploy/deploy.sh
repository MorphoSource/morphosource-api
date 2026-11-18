#!/bin/sh
# Runs the publish Job on the cluster the current `oc` session points at and waits for it.
#
# Env: IMAGE (docs image to publish), RELEASE (release id, e.g. the commit SHA).
set -eu

: "${IMAGE:?IMAGE must be set}"
: "${RELEASE:?RELEASE must be set}"

JOB="api-docs-publish-$RELEASE"
TIMEOUT_SECONDS=300

oc delete job "$JOB" --ignore-not-found --wait=true
sed -e "s#__JOB_NAME__#$JOB#g" -e "s#__IMAGE__#$IMAGE#g" -e "s#__RELEASE__#$RELEASE#g" \
  "$(dirname "$0")/publish-job.yaml" | oc create -f -

elapsed=0
while [ "$elapsed" -lt "$TIMEOUT_SECONDS" ]; do
  succeeded=$(oc get job "$JOB" -o jsonpath='{.status.succeeded}')
  failed=$(oc get job "$JOB" -o jsonpath='{.status.failed}')
  if [ "${succeeded:-0}" -ge 1 ]; then
    oc logs "job/$JOB"
    exit 0
  fi
  if [ "${failed:-0}" -ge 1 ]; then
    echo "Publish job failed:" >&2
    oc describe "job/$JOB" >&2 || true
    oc logs "job/$JOB" >&2 || true
    exit 1
  fi
  sleep 5
  elapsed=$((elapsed + 5))
done

echo "Timed out after ${TIMEOUT_SECONDS}s waiting for $JOB" >&2
oc describe "job/$JOB" >&2 || true
oc logs "job/$JOB" >&2 || true
exit 1
