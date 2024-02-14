# System Monitor Script

This repository contains a simple bash script for monitoring key system metrics on your Linux machine. It checks CPU temperature, memory usage, and disk space, providing alerts if certain thresholds are exceeded.

This script was tested and run on an Acer Nitro. In some cases, it may be necessary to modify the GPU and CPU sensor lines for accuracy on other machine models.

## Features

- **CPU and GPU Temperature Monitoring**: Alerts if the CPU temperature exceeds a set threshold.
- **Memory Usage Monitoring**: Alerts if the memory usage exceeds a set threshold.
- **Disk Space Monitoring**: Displays the current disk space usage.

## Requirements

- Linux operating system
- `lm-sensors` installed for CPU temperature monitoring

## Installation

1. Clone the repository or download the `system_monitor.sh` script.
2. Make sure `lm-sensors` is installed on your system. If not, install it using your package manager. For example, on Debian/Ubuntu:
   ```bash
   sudo apt-get install lm-sensors
   ```
3. Make the script executable:
   ```bash
   chmod +x monitor.sh
   ```

## Usage

Run the script from the terminal:
```bash
./monitor.sh
```

## Configuration

- You can set the temperature and memory thresholds at the beginning of the script.
- The default temperature threshold is set to 70°C.
- The default memory usage threshold is set to 80%.

## Contributing

Contributions to this script are welcome. Feel free to fork the repository and submit pull requests.

## License

This script is released under the MIT License. See the `LICENSE` file for more details.
