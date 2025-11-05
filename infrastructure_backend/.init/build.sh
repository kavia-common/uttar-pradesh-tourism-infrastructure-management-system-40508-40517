#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/uttar-pradesh-tourism-infrastructure-management-system-40508-40517/infrastructure_backend"
PROFILE="/etc/profile.d/java_maven.sh"
if [ ! -r "$PROFILE" ]; then echo "ERROR: $PROFILE missing; run install step" >&2; exit 2; fi
# shellcheck disable=SC1090
source "$PROFILE"
cd "$WORKSPACE"
if ! command -v mvn >/dev/null 2>&1; then echo "ERROR: mvn not available" >&2; exit 3; fi
mvn -B -DskipTests package
