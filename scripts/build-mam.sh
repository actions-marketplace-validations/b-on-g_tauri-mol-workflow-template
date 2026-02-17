#!/usr/bin/env bash
set -euo pipefail

MODULE_PATH="${1:?Usage: build-mam.sh <module_path> [dist_path]}"
DIST_PATH="${2:-${MODULE_PATH}/-}"
WAIT_SECONDS="${WAIT_SECONDS:-180}"

echo "[mam] build start: module=${MODULE_PATH}, dist=${DIST_PATH}"

npx mam "${MODULE_PATH}" &
MAM_PID=$!

cleanup() {
  kill "${MAM_PID}" 2>/dev/null || true
}

trap cleanup EXIT

for ((i=1; i<=WAIT_SECONDS; i++)); do
  if [[ -d "${DIST_PATH}" ]]; then
    if [[ -f "${DIST_PATH}/web.js" || -f "${DIST_PATH}/index.html" || -f "${DIST_PATH}/web.css" ]]; then
      echo "[mam] build ready in ${DIST_PATH}"
      exit 0
    fi
  fi

  if ! kill -0 "${MAM_PID}" 2>/dev/null; then
    echo "[mam] process exited before bundle was detected"
    exit 1
  fi

  sleep 1
done

echo "[mam] timeout waiting for bundle: ${DIST_PATH}"
exit 1
