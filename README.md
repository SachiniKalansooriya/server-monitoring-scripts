# Server Monitoring Scripts

Multi-server monitoring and alerting scripts using Bash on Ubuntu Linux.
Monitors server reachability and HTTP responses automatically.

## Environment
- OS: Ubuntu 22.04 on WSL2
- Shell: Bash
- Date: April 2026

## Scripts

### server-monitor.sh
Monitors multiple servers using ping and HTTP checks and generates a report.

**Usage:**
```bash
./scripts/server-monitor.sh
```

**What it does:**
- Pings each server to check if it is reachable
- Sends HTTP request and checks response code
- Counts how many servers are UP and DOWN
- Generates a dated report file in reports/
- Logs every check with timestamp to logs/monitor.log

**Sample output**

<img width="1197" height="759" alt="image" src="https://github.com/user-attachments/assets/d2a7d694-3525-453d-9108-6fff1d7b1304" />

## HTTP Response Codes

| Code | Meaning | Treated as |
|---|---|---|
| 200 | Success | OK |
| 301 | Permanent redirect | OK |
| 302 | Temporary redirect | OK |
| 404 | Not found | FAIL |
| 500 | Server error | FAIL |
| 000 | No response | FAIL |

## Bash Concepts Used

### Functions
```bash
check_server() {
    SERVER=$1
    # $1 is the first argument passed to the function
}
check_server google.com
```

### Return codes
```bash
return 0    # success
return 1    # failure
$?          # reads return code of last function or command
```

### Multiple conditions
```bash
if [ "$CODE" = "200" ] || [ "$CODE" = "301" ]; then
    # || means OR — true if either condition matches
fi
```

### Report generation
```bash
{
    echo "line 1"
    echo "line 2"
} > report.txt
# { } groups multiple echo commands into one file
```

## Commands Used

| Command | What it does |
|---|---|
| ping -c 1 -W 2 server | Send 1 ping, wait max 2 seconds |
| curl -s -o /dev/null -w "%{http_code}" URL | Get HTTP status code only |
| curl --max-time 5 URL | Timeout after 5 seconds |
| > /dev/null 2>&1 | Hide all output including errors |
| return 0 | Return success from function |
| return 1 | Return failure from function |
| $? | Exit code of last command or function |

## Log Files
- logs/monitor.log — all checks with timestamps
- reports/report_YYYY-MM-DD.txt — daily summary report

## Skills Demonstrated
- Bash functions with arguments and return codes
- Network monitoring with ping and curl
- HTTP response code checking
- Multiple condition handling with OR operator
- Report generation using grouped commands
- Structured logging with timestamps
- Git version control and GitHub
