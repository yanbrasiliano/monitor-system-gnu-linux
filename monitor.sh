#!/usr/bin/env bash

TEMP_CPU_THRESHOLD=70 # CPU Temperature in Celsius
TEMP_GPU_THRESHOLD=70 # GPU Temperature in Celsius
MEM_THRESHOLD=80      # Memory usage in percentage
DISK_THRESHOLD=80     # Disk usage in percentage

echo "Checking system..."

# CPU Temperature
CPU_TEMP=$(sensors 2>/dev/null | awk '/Tctl:/ {print $2}' | tr -d '+°C')
echo "Retrieved CPU Temperature: $CPU_TEMP°C"
if [[ $CPU_TEMP =~ ^[0-9]+([.][0-9]+)?$ ]]; then
  echo "CPU Temperature: $CPU_TEMP°C"
  if (($(echo "$CPU_TEMP > $TEMP_CPU_THRESHOLD" | bc -l))); then
    echo "ALERT: High CPU temperature!"
  else
    echo "CPU temperature is within normal range."
  fi
else
  echo "CPU Temperature: Not available"
fi

# GPU Temperature
GPU_TEMP=$(sensors 2>/dev/null | awk '/edge:/ {print $2}' | tr -d '+°C')
echo "Retrieved GPU Temperature: $GPU_TEMP°C"
if [[ $GPU_TEMP =~ ^[0-9]+([.][0-9]+)?$ ]]; then
  echo "GPU Temperature: $GPU_TEMP°C"
  if (($(echo "$GPU_TEMP > $TEMP_GPU_THRESHOLD" | bc -l))); then
    echo "ALERT: High GPU temperature!"
  else
    echo "GPU temperature is within normal range."
  fi
else
  echo "GPU Temperature: Not available"
fi

# Memory Usage
MEM_USED=$(free -m | awk '/Mem:/ {print $3/$2 * 100.0}')
MEM_USED_FORMATTED=$(printf "%.2f" $MEM_USED 2>/dev/null)
echo "Retrieved Memory Usage: $MEM_USED_FORMATTED%"
if (($(echo "$MEM_USED > $MEM_THRESHOLD" | bc -l 2>/dev/null))); then
  echo "ALERT: High memory usage!"
else
  echo "Memory usage is within normal range."
fi

# Disk Space
check_disk_usage() {
  local partition=$1
  local usage=$(df -h | awk -v partition="$partition" '$NF==partition {print $5}' | tr -d '%')
  echo "Checking Disk Space on $partition: $usage%"
  if [ ! -z "$usage" ]; then
    if ((usage > DISK_THRESHOLD)); then
      echo "ALERT: High disk usage on $partition!"
    else
      echo "Disk usage on $partition is within normal range."
    fi
  else
    echo "Disk Space information for $partition is not available."
  fi
}

check_disk_usage '/'
check_disk_usage '/home'

echo "System check complete."
