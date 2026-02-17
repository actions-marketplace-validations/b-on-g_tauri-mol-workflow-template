#!/usr/bin/env bash
set -euo pipefail

MODULE_PATH="${1:?Usage: configure-tauri-path.sh <module_path> [port]}"
PORT="${2:-9080}"

DEV_URL="http://localhost:${PORT}/${MODULE_PATH}/"
FRONTEND_DIST="../${MODULE_PATH}/-"

node -e '
const fs = require("fs");
const file = process.argv[1];
const devUrl = process.argv[2];
const frontendDist = process.argv[3];
const conf = JSON.parse(fs.readFileSync(file, "utf8"));
conf.build = conf.build || {};
conf.build.devUrl = devUrl;
conf.build.frontendDist = frontendDist;
fs.writeFileSync(file, JSON.stringify(conf, null, 2) + "\n");
' \
"src-tauri/tauri.conf.json" \
"${DEV_URL}" \
"${FRONTEND_DIST}"

echo "[tauri] devUrl=${DEV_URL}"
echo "[tauri] frontendDist=${FRONTEND_DIST}"
