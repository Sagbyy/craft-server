#!/bin/bash

set -e

# Configuration
FLUTTER_SDK_PATH="/boot/flutter"
LOG_FILE="/var/log/flutter_check.log"
USER="modo"
SERVICE_PATH="/etc/systemd/system"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
INSTALL_DIR="/opt/craft-server/scripts"

# Function to log messages with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Function to install Flutter SDK globally
install_flutter() {
    # Clean up any failed installation
    rm -rf "$FLUTTER_SDK_PATH"
    
    # Create Flutter directory
    mkdir -p "$FLUTTER_SDK_PATH"
    
    # Download and extract Flutter SDK
    cd /boot
    git clone https://github.com/flutter/flutter.git -b stable
    
    # Make Flutter accessible to all users
    chmod -R 755 "$FLUTTER_SDK_PATH"
    
    # Add Flutter to PATH system-wide
    cat > /etc/profile.d/flutter.sh << 'EOL'
export PATH="$PATH:/boot/flutter/bin"
EOL
    chmod 644 /etc/profile.d/flutter.sh
    
    # Initial setup of Flutter
    export PATH="$PATH:/boot/flutter/bin"
    # Run flutter precache with minimal components to save space
    flutter precache --no-android --no-ios --no-linux --no-macos --no-windows --no-fuchsia
}

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

# If the script is called with --check-only, run only the check
if [ "$1" == "--check-only" ]; then
    # Clear previous log file
    echo "" > "$LOG_FILE"

    # Start logging
    log_message "Starting Flutter environment integrity check" >> "$LOG_FILE"

    # Check if Flutter SDK directory exists
    if [ ! -d "$FLUTTER_SDK_PATH" ]; then
        log_message "Flutter SDK not found. Installing..." >> "$LOG_FILE"
        install_flutter
        log_message "Flutter SDK installed successfully" >> "$LOG_FILE"
    fi

    log_message "Flutter SDK directory found at $FLUTTER_SDK_PATH" >> "$LOG_FILE"

    # Run flutter doctor and capture output
    export PATH="$PATH:$FLUTTER_SDK_PATH/bin"
    flutter doctor > >(tee -a "$LOG_FILE") 2>&1
    FLUTTER_DOCTOR_EXIT_CODE=$?

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
    
    # Install Flutter if not already installed
    if [ ! -d "$FLUTTER_SDK_PATH" ]; then
        echo "Installing Flutter SDK..."
        install_flutter
        echo "Flutter SDK installed successfully!"
    fi
    
    # Activate and start the service and the timer
    systemctl daemon-reload
    systemctl enable flutter-check.timer
    systemctl start flutter-check.timer
    
    echo "Service and timer installed successfully!"
    echo "The check script will run automatically every day"
    echo "To see logs: cat $LOG_FILE"
    echo "To see the timer status: systemctl status flutter-check.timer"
    echo "To check now: systemctl start flutter-check.service"
    echo ""
    echo "Flutter is now installed and available system-wide"
    echo "Please log out and log back in, or run:"
    echo "source /etc/profile.d/flutter.sh"
    echo "to start using Flutter immediately"
fi
