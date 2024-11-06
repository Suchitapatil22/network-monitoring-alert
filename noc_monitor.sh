#!/bin/bash

# Set up log and alert files
LOGFILE="./logs/noc_monitor.log"
ALERTFILE="./logs/noc_alerts.log"
exec > >(tee -a "$LOGFILE") 2>&1

# Detect active IPs in the 172.30.1.x network, excluding your system's IP
MY_IP="172.30.1.2"
IPS=($(nmap -sn 172.30.1.0/24 | grep "Nmap scan report for" | awk '{print $5}' | grep -v "$MY_IP"))

# List of ports to check on each IP
PORTS=(80 443 22 3306)

# Threshold for packet loss (percentage)
THRESHOLD=20

# Function to check if a host is up
check_host() {
    local ip=$1
    echo "Pinging $ip..."
    LOSS=$(ping -c 5 $ip | grep -oP '\d+(?=% packet loss)')

    if [ -z "$LOSS" ]; then
        LOSS=100
    fi

    if [ "$LOSS" -ge "$THRESHOLD" ]; then
        echo "$(date): ALERT: $ip is down or packet loss is $LOSS%" | tee -a "$ALERTFILE"
    else
        echo "$(date): $ip is up with $LOSS% packet loss."
    fi
}

# Function to check open ports
check_port() {
    local ip=$1
    local port=$2
    echo "Checking port $port on $ip..."

    timeout 1 bash -c "</dev/tcp/$ip/$port" && \
    echo "$(date): Port $port on $ip is open." || \
    echo "$(date): ALERT: Port $port on $ip is closed." | tee -a "$ALERTFILE"
}

# Function to monitor system logs for specific keywords
monitor_logs() {
    local logfile=$1
    echo "Monitoring $logfile for keywords..."

    tail -Fn0 $logfile | while read line; do
        echo "$line" | grep -E "error|critical|failure" && \
        echo "$(date): ALERT in $logfile: $line" | tee -a "$ALERTFILE"
    done
}

# Main script execution
echo "Starting NOC Monitoring..."

# Check each IP for network connectivity and port status
for ip in "${IPS[@]}"; do
    check_host $ip
    for port in "${PORTS[@]}"; do
        check_port $ip $port
    done
done

# Monitor system logs for keywords
LOGS_TO_MONITOR=("/var/log/syslog" "/var/log/auth.log")
for logfile in "${LOGS_TO_MONITOR[@]}"; do
    monitor_logs $logfile &
done

echo "NOC Monitoring script running. Logs are available at $LOGFILE and alerts at $ALERTFILE"

