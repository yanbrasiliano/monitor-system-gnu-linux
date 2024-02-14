#!/usr/bin/env bash

set -euo pipefail

# Set thresholds
TEMP_CPU_THRESHOLD=70 # CPU Temperature in Celsius
TEMP_GPU_THRESHOLD=70 # GPU Temperature in Celsius
MEM_THRESHOLD=80      # Memory usage in percentage
DISK_THRESHOLD=80     # Disk usage in percentage

echo "Checking system..."

# CPU Temperature
CPU_TEMP=$(sensors 2>/dev/null | awk '/Tctl:/ {print $2}' | tr -d '+°C')
if [[ $CPU_TEMP =~ ^[0-9]+([.][0-9]+)?$ ]]; then
  echo "CPU Temperature: $CPU_TEMP°C"
  if (($(echo "$CPU_TEMP > $TEMP_CPU_THRESHOLD" | bc -l))); then
    echo "ALERT: High CPU temperature!"
  fi
else
  echo "CPU Temperature: Not available"
fi

# GPU Temperature
GPU_TEMP=$(sensors 2>/dev/null | awk '/edge:/ {print $2}' | tr -d '+°C')
if [[ $GPU_TEMP =~ ^[0-9]+([.][0-9]+)?$ ]]; then
  echo "GPU Temperature: $GPU_TEMP°C"
  if (($(echo "$GPU_TEMP > $TEMP_GPU_THRESHOLD" | bc -l))); then
    echo "ALERT: High GPU temperature!"
  fi
else
  echo "GPU Temperature: Not available"
fi

# Memory Usage
MEM_USED=$(free -m | awk '/Mem:/ {print $3/$2 * 100.0}')
MEM_USED_FORMATTED=$(printf "%.2f" $MEM_USED 2>/dev/null)
echo "Memory Usage: $MEM_USED_FORMATTED%"
if (($(echo "$MEM_USED > $MEM_THRESHOLD" | bc -l 2>/dev/null))); then
  echo "ALERT: High memory usage!"
fi

# Disk Space
check_disk_usage() {
  local partition=$1
  local usage=$(df -h | awk -v partition="$partition" '$NF==partition {print $5}' | tr -d '%')
  if [ ! -z "$usage" ]; then
    echo "Disk Space on $partition: $usage%"
    if ((usage > DISK_THRESHOLD)); then
      echo "ALERT: High disk usage on $partition!"
    fi
  fi
}

check_disk_usage '/'
check_disk_usage '/home'

echo "System check complete."
