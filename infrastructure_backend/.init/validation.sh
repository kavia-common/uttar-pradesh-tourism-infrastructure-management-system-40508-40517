#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/uttar-pradesh-tourism-infrastructure-management-system-40508-40517/infrastructure_backend"
PROFILE="/etc/profile.d/java_maven.sh"
if [ ! -r "$PROFILE" ]; then echo "ERROR: $PROFILE missing; run install step" >&2; exit 2; fi
# shellcheck disable=SC1090
source "$PROFILE"
cd "$WORKSPACE"
if ! command -v mvn >/dev/null 2>&1; then echo "ERROR: mvn not available" >&2; exit 3; fi
# Build (skip tests)
mvn -B -DskipTests package
# Find runnable jar (spring-boot-maven-plugin produces one executable jar in target)
JAR=$(ls -1 target/*jar 2>/dev/null | grep -v "-original" | head -n1 || true)
if [ -z "$JAR" ]; then echo "ERROR: no jar found in target" >&2; ls -la target || true; exit 4; fi
# Start app directly and capture PID
LOG_OUT=/tmp/app_stdout.log
LOG_ERR=/tmp/app_stderr.log
JAVA_OPTS="-Xmx512m -Dserver.address=0.0.0.0 -Dserver.port=8080 -Dspring.profiles.active=dev"
java $JAVA_OPTS -jar "$JAR" >"$LOG_OUT" 2>"$LOG_ERR" &
APP_PID=$!
# ensure pid record for stop script
echo "$APP_PID" >/tmp/app_pid.txt
cleanup(){
  if ps -p "$APP_PID" >/dev/null 2>&1; then kill "$APP_PID" || true; sleep 1; fi
}
trap cleanup EXIT
# Wait a short while for JVM to initialize
sleep 1
if ! ps -p "$APP_PID" -o comm= >/dev/null 2>&1; then
  echo "ERROR: launched PID $APP_PID not running; printing logs" >&2
  echo "--- stdout ---"; tail -n +1 "$LOG_OUT" || true
  echo "--- stderr ---"; tail -n +1 "$LOG_ERR" || true
  exit 5
fi
# Poll health endpoint
HEALTH_URL="http://127.0.0.1:8080/actuator/health"
MAX_ATTEMPTS=20
SLEEP=1
OK=false
for i in $(seq 1 $MAX_ATTEMPTS); do
  if command -v curl >/dev/null 2>&1; then
    code=$(curl -sS -o /dev/null -w "%{http_code}" --max-time 2 "$HEALTH_URL" || echo 000)
  else
    wget -q --tries=1 --timeout=2 -O /dev/null "$HEALTH_URL" && code=200 || code=000
  fi
  if [ "$code" = "200" ]; then OK=true; break; fi
  sleep $SLEEP
done
if ! $OK; then
  echo "ERROR: healthcheck failed after $((MAX_ATTEMPTS*SLEEP))s" >&2
  echo "--- stdout ---"; tail -n +1 "$LOG_OUT" || true
  echo "--- stderr ---"; tail -n +1 "$LOG_ERR" || true
  cleanup
  exit 6
fi
echo "validation: app responded with HTTP 200 at $HEALTH_URL"
# Clean up explicitly (trap will also run)
cleanup
exit 0
