# 📡 Network Monitoring and Alerting System

This **Network Monitoring and Alerting System** script provides real-time monitoring for network connectivity, essential port statuses, and system log alerts. Designed to help maintain network reliability, this tool is ideal for Network Operations Centers (NOCs) or personal network monitoring.

## 📋 Features
- 🌐 **IP Monitoring**: Detects active IPs in a specified network range and measures packet loss.
- 🔍 **Port Scanning**: Checks the status of essential ports like 80, 443, 22, and 3306.
- 📂 **Log Monitoring**: Tracks system logs for keywords like `error`, `critical`, and `failure`.
- ⚠️ **Alert System**: Logs alerts for high packet loss or closed ports to help with quick responses.

## 🚀 Getting Started

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Suchitapatil22/network-monitoring-alert.git
   cd network-monitoring-alert
2. Run the Script:

   Make the script executable and start it
   ```bash
   chmod +x noc_monitor.sh
   ./noc_monitor.sh

3. View Logs and Alerts:

   Logs: Monitor general activity in  
      ```bash  
             ./logs/noc_monitor.log.


  Alerts: See specific alerts in
    ```bash  

     ./logs/noc_alerts.log.


  🔧 Configuration
  Adjust the IP range, monitored ports, and packet loss threshold in the script settings as needed.
  
  💡 How It Works
  Network Check: Scans each active IP for connectivity and reports packet loss.
  Port Status: Verifies accessibility of critical ports.
  Keyword Monitoring: Watches system logs for critical issues.
