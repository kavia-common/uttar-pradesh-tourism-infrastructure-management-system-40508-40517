#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/uttar-pradesh-tourism-infrastructure-management-system-40508-40517/infrastructure_backend"
PROFILE="/etc/profile.d/java_maven.sh"
if [ ! -r "$PROFILE" ]; then echo "ERROR: $PROFILE missing; run install step" >&2; exit 2; fi
# shellcheck disable=SC1090
source "$PROFILE"
cd "$WORKSPACE"
if ! command -v mvn >/dev/null 2>&1; then echo "ERROR: mvn not found" >&2; exit 3; fi
mvn -v || true
# Run tests (non-interactive)
if ! mvn -B -DskipTests=false test; then
  echo "Tests failed; collecting surefire reports..." >&2
  ls -la target/surefire-reports || true
  sed -n '1,200p' target/surefire-reports/*.txt 2>/dev/null || true
  echo "Re-running tests with debug output..." >&2
  mvn -B -X test || true
  exit 4
fi
exit 0
