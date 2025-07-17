#!/bin/bash

set -e

# Configuration
FLUTTER_SDK_PATH="/home/modo/flutter"
LOG_FILE="/var/log/flutter_check.log"
USER="modo"
SERVICE_PATH="/etc/systemd/system"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
INSTALL_DIR="/opt/craft-server/scripts"

# Create the user if it doesn't exist
if ! id "$USER" &>/dev/null; then
    useradd -m -s /bin/bash "$USER"
    # Add user to necessary groups
    usermod -aG sudo "$USER"
fi

# Create the log file and configure the permissions
touch "$LOG_FILE"
chown "$USER:$USER" "$LOG_FILE"
chmod 644 "$LOG_FILE"

# Create installation directory and copy script if needed
mkdir -p "$INSTALL_DIR"
if [ "$SCRIPT_DIR" != "$INSTALL_DIR" ]; then
    cp "$SCRIPT_DIR/setup-flutter.sh" "$INSTALL_DIR/"
fi
chmod 755 "$INSTALL_DIR/setup-flutter.sh"
chown "$USER:$USER" "$INSTALL_DIR/setup-flutter.sh"

# Function to log messages with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# If the script is called with --check-only, run only the check
if [ "$1" == "--check-only" ]; then
    # Clear previous log file
    echo "" > "$LOG_FILE"

    # Start logging
    log_message "Starting Flutter environment integrity check" >> "$LOG_FILE"

    # Check if Flutter SDK directory exists
    if [ ! -d "$FLUTTER_SDK_PATH" ]; then
        log_message "ERROR: Flutter SDK directory not found at $FLUTTER_SDK_PATH" >> "$LOG_FILE"
        exit 1
    fi

    log_message "Flutter SDK directory found at $FLUTTER_SDK_PATH" >> "$LOG_FILE"

    # Run flutter doctor and capture output
    FLUTTER_DOCTOR_OUTPUT=$($FLUTTER_SDK_PATH/bin/flutter doctor 2>&1)
    FLUTTER_DOCTOR_EXIT_CODE=$?

    # Log flutter doctor output
    log_message "Flutter Doctor Output:" >> "$LOG_FILE"
    echo "$FLUTTER_DOCTOR_OUTPUT" >> "$LOG_FILE"

    # Check flutter doctor exit code
    if [ $FLUTTER_DOCTOR_EXIT_CODE -eq 0 ]; then
        log_message "Flutter environment check completed successfully" >> "$LOG_FILE"
        exit 0
    else
        log_message "ERROR: Flutter environment check failed with exit code $FLUTTER_DOCTOR_EXIT_CODE" >> "$LOG_FILE"
        exit 1
    fi
else
    # Copy the service and timer files
    cp "$PROJECT_ROOT/configs/flutter-check.service" "$SERVICE_PATH/"
    cp "$PROJECT_ROOT/configs/flutter-check.timer" "$SERVICE_PATH/"
    chmod 644 "$SERVICE_PATH/flutter-check.service"
    chmod 644 "$SERVICE_PATH/flutter-check.timer"
    
    # Activate and start the service and the timer
    systemctl daemon-reload
    systemctl enable flutter-check.timer
    systemctl start flutter-check.timer
    
    echo "Service and timer installed successfully!"
    echo "The check script will run automatically every day"
    echo "To see logs: cat $LOG_FILE"
    echo "To see the timer status: systemctl status flutter-check.timer"
    echo "To check now: systemctl start flutter-check.service"
fi
