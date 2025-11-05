#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/uttar-pradesh-tourism-infrastructure-management-system-40508-40517/infrastructure_backend"
PROFILE="/etc/profile.d/java_maven.sh"
if [ ! -r "$PROFILE" ]; then echo "ERROR: $PROFILE missing; run install step" >&2; exit 2; fi
# shellcheck disable=SC1090
source "$PROFILE"
cd "$WORKSPACE"
JAR=$(ls -1 target/*jar 2>/dev/null | grep -v "-original" | head -n1 || true)
if [ -z "$JAR" ]; then echo "ERROR: no jar found in target" >&2; ls -la target || true; exit 4; fi
LOG_OUT=/tmp/app_stdout.log
LOG_ERR=/tmp/app_stderr.log
JAVA_OPTS="-Xmx512m -Dserver.address=0.0.0.0 -Dserver.port=8080 -Dspring.profiles.active=dev"
java $JAVA_OPTS -jar "$JAR" >"$LOG_OUT" 2>"$LOG_ERR" &
APP_PID=$!
echo "$APP_PID" >/tmp/app_pid.txt
# Provide cleanup function for safe stop
cleanup(){
  if ps -p "$APP_PID" >/dev/null 2>&1; then kill "$APP_PID" || true; sleep 1; fi
}
trap cleanup EXIT
# Give a moment to start
sleep 1
if ! ps -p "$APP_PID" -o comm= >/dev/null 2>&1; then
  echo "ERROR: launched PID $APP_PID not running; printing logs" >&2
  echo "--- stdout ---"; tail -n +1 "$LOG_OUT" || true
  echo "--- stderr ---"; tail -n +1 "$LOG_ERR" || true
  exit 5
fi
# leave process running; the validation script will poll and stop it
echo "started:$APP_PID"
