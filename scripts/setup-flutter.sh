#!/bin/bash

FLUTTER_SDK="/opt/flutter"
FLUTTER_VERSION="stable"
LOG_FILE="/var/log/flutter_integrity.log"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/$FLUTTER_VERSION/linux/flutter_linux_$FLUTTER_VERSION.tar.xz"

echo "Création du répertoire /opt/flutter"
mkdir -p /opt/flutter
chown -R modo:modo /opt/flutter

: > "$LOG_FILE"
echo "=== Vérification Flutter - $(date '+%Y-%m-%d %H:%M:%S') ===" >> "$LOG_FILE"

if [ ! -d "$FLUTTER_SDK" ]; then
    echo "[INFO] Flutter SDK non trouvé. Installation en cours..." >> "$LOG_FILE"
    
    TEMP_DIR=$(mktemp -d)
    wget -O "$TEMP_DIR/flutter.tar.xz" "$FLUTTER_URL" >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        echo "[ERREUR] Échec du téléchargement de Flutter." >> "$LOG_FILE"
        exit 1
    fi

    sudo mkdir -p "$FLUTTER_SDK"
    sudo tar xf "$TEMP_DIR/flutter.tar.xz" -C /opt >> "$LOG_FILE" 2>&1
    sudo mv /opt/flutter "$FLUTTER_SDK" 2>/dev/null || true
    rm -rf "$TEMP_DIR"

    echo "[INFO] Flutter SDK installé dans $FLUTTER_SDK" >> "$LOG_FILE"
fi

export PATH="$FLUTTER_SDK/bin:$PATH"

if ! command -v flutter &> /dev/null; then
    echo "[ERREUR] La commande 'flutter' est introuvable après installation." >> "$LOG_FILE"
    exit 2
fi

flutter precache >> "$LOG_FILE" 2>&1

flutter doctor -v >> "$LOG_FILE" 2>&1
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo "[ERREUR] flutter doctor a échoué (code: $EXIT_CODE)." >> "$LOG_FILE"
    exit 3
else
    echo "[OK] flutter doctor terminé avec succès." >> "$LOG_FILE"

    sudo systemctl daemon-reexec
    sudo systemctl daemon-reload
    sudo systemctl enable flutter-check.timer
    sudo systemctl start flutter-check.timer

    echo "[OK] flutter-check.timer a été activé et démarré." >> "$LOG_FILE"

    systemctl list-timers | grep flutter-check

    sudo systemctl start flutter-check.service

    cat /var/log/flutter_integrity.log

    exit 0
fi
