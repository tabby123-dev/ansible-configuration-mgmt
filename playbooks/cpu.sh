```bash
#!/bin/bash

# ==========================================
# Server Resource Monitoring Script
# Checks CPU and RAM utilization
# ==========================================

HOSTNAME=$(hostname)
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# CPU usage
CPU_USAGE=$(top -bn1 | awk '/Cpu\(s\)/ {
    printf "%.2f", 100 - $8
}')

# Memory usage
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_AVAILABLE=$(free -m | awk '/Mem:/ {print $7}')

MEM_USAGE=$(awk "BEGIN {printf \"%.2f\", ($MEM_USED/$MEM_TOTAL)*100}")

# Load average
LOAD_AVG=$(awk '{print $1}' /proc/loadavg)

# Output
echo "=========================================="
echo " Server Resource Report"
echo "=========================================="
echo "Hostname       : $HOSTNAME"
echo "IP Address     : $IP_ADDRESS"
echo "CPU Usage      : ${CPU_USAGE}%"
echo "RAM Usage      : ${MEM_USAGE}%"
echo "RAM Total      : ${MEM_TOTAL} MB"
echo "RAM Used       : ${MEM_USED} MB"
echo "RAM Available  : ${MEM_AVAILABLE} MB"
echo "Load Average   : ${LOAD_AVG}"
echo "=========================================="
```
