#!/bin/bash
# Multi-Server Monitoring Script
# Monitors multiple servers and generates a report

DATE=$(date '+%Y-%m-%d %H:%M:%S')
LOG="logs/monitor.log"
REPORT="reports/report_$(date '+%Y-%m-%d').txt"

mkdir -p logs reports

SERVERS=("google.com" "github.com" "stackoverflow.com")

echo ""
echo "  Server Monitor Report"
echo "  $DATE"
echo ""
echo ""

check_server() {
    SERVER=$1
    if ping -c 1 -W 2 $SERVER > /dev/null 2>&1; then
        echo "  OK    $SERVER is REACHABLE"
        echo "[$DATE] OK: $SERVER is REACHABLE" >> $LOG
        return 0
    else
        echo "  FAIL  $SERVER is UNREACHABLE"
        echo "[$DATE] FAIL: $SERVER is UNREACHABLE" >> $LOG
        return 1
    fi
}

check_http() {
    SERVER=$1
    CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 https://$SERVER)
    if [ "$CODE" = "200" ] || [ "$CODE" = "301" ] || [ "$CODE" = "302" ]; then
        echo "  OK    $SERVER HTTP response: $CODE"
        echo "[$DATE] OK: $SERVER HTTP $CODE" >> $LOG
    else
        echo "  FAIL  $SERVER HTTP response: $CODE"
        echo "[$DATE] FAIL: $SERVER HTTP $CODE" >> $LOG
    fi
}

echo "PING CHECKS:"
UP_COUNT=0
DOWN_COUNT=0

for SERVER in "${SERVERS[@]}"; do
    check_server $SERVER
    if [ $? -eq 0 ]; then
        UP_COUNT=$((UP_COUNT + 1))
    else
        DOWN_COUNT=$((DOWN_COUNT + 1))
    fi
done

echo ""
echo "HTTP CHECKS:"
for SERVER in "${SERVERS[@]}"; do
    check_http $SERVER
done

TOTAL=${#SERVERS[@]}
echo ""
echo ""
echo "  SUMMARY"
echo "  Total servers : $TOTAL"
echo "  UP            : $UP_COUNT"
echo "  DOWN          : $DOWN_COUNT"
echo ""

{
    echo "Server Monitor Report - $DATE"
    echo ""
    echo "Total: $TOTAL | UP: $UP_COUNT | DOWN: $DOWN_COUNT"
    echo ""
} > $REPORT

echo "Report saved: $REPORT"
echo "[$DATE] SUMMARY: $TOTAL servers | UP: $UP_COUNT | DOWN: $DOWN_COUNT" >> $LOG
