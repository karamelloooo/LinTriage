#!/bin/bash

# Start timer
START_TIME=$(date +%s)

# Default values
MEMORY_DUMP=false
OUTPUT_DIR="forensic_logs_$(date +%Y%m%d_%H%M%S)"

# Help function
function show_help() {
  echo "                                                                  "
  echo "██╗     ██╗███╗   ██╗████████╗██████╗ ██╗ █████╗  ██████╗ ███████╗"
  echo "██║     ██║████╗  ██║╚══██╔══╝██╔══██╗██║██╔══██╗██╔════╝ ██╔════╝"
  echo "██║     ██║██╔██╗ ██║   ██║   ██████╔╝██║███████║██║  ███╗█████╗  "
  echo "██║     ██║██║╚██╗██║   ██║   ██╔══██╗██║██╔══██║██║   ██║██╔══╝  "
  echo "███████╗██║██║ ╚████║   ██║   ██║  ██║██║██║  ██║╚██████╔╝███████╗"
  echo "╚══════╝╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝"
  echo "                                                                  "
  echo "LinTriage v1.0 - Linux Forensic Triage Tool"
  echo ""
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -h, --help         Show this help message and exit"
  echo "  -md, --memorydump  Collect a full memory dump (using AVML)"
  echo "  -o,  --output DIR  Specify output directory (default: forensic_logs_YYYYMMDD_HHMMSS)"
  echo ""
  echo "Example:"
  echo "  $0 --memorydump --output /mnt/triage"
  exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_help
      ;;
    -md|--memorydump)
      MEMORY_DUMP=true
      ;;
    -o|--output)
      shift
      OUTPUT_DIR="$1"
      ;;
    *)
      echo "Unknown option: $1"
      show_help
      ;;
  esac
  shift
done

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "Error: This script must be run as root!"
  exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"
echo "Saving logs to: $OUTPUT_DIR"

# Collect hostname
echo -n "Collecting system hostname... "
echo "Hostname: $(hostname)" > "$OUTPUT_DIR/hostname.txt"
echo "Done."

# Collect filesystem information
echo -n "Collecting filesystem information... "
df -h > "$OUTPUT_DIR/filesystem_info.txt"
mount > "$OUTPUT_DIR/mounted_filesystems.txt"
echo "Done."

# Collect running processes
echo -n "Collecting process information... "
ps aux > "$OUTPUT_DIR/processes.txt"
echo "Done."

# Collect network connections
echo -n "Collecting network connections... "
ss -tulpan > "$OUTPUT_DIR/network_connections.txt"
echo "Done."

# Collect memory dump if flag is set
if [ "$MEMORY_DUMP" = true ]; then
  echo -n "Collecting memory dump... "

  AVML_BIN="./tools/avml"
  DUMP_PATH="$OUTPUT_DIR/memdump.lime"

  if [ ! -f "$AVML_BIN" ]; then
    echo "Error: AVML not found in $AVML_BIN! Make sure it's in the 'tools/' folder."
    exit 1
  fi

  sudo "$AVML_BIN" "$DUMP_PATH"

  echo "Done. Memory dump saved to $DUMP_PATH"
fi

# Collect system logs
echo -n "Collecting system logs... "
cp -r /var/log "$OUTPUT_DIR/" 2>/dev/null
echo "Done."

# Compress collected data using tar.gz
echo -n "Compressing logs... "
tar -czf "$OUTPUT_DIR.tar.gz" "$OUTPUT_DIR" >/dev/null
echo "Done."

# Remove original folder
echo -n "Cleaning up... "
rm -rf "$OUTPUT_DIR"
echo "Done."

# End timer and calculate duration
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo "Log collection complete: $OUTPUT_DIR.tar.gz"
echo "Total time taken: $DURATION seconds"
