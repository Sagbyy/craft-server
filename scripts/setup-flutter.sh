#!/bin/bash

FLUTTER_SDK="/opt/flutter"
LOG_FILE="/var/log/flutter_integrity.log"

: > "$LOG_FILE"

echo "=== Vérification Flutter - $(date '+%Y-%m-%d %H:%M:%S') ===" >> "$LOG_FILE"

if [ ! -d "$FLUTTER_SDK" ]; then
    echo "[ERREUR] Le dossier du SDK Flutter ($FLUTTER_SDK) est introuvable." >> "$LOG_FILE"
    exit 1
fi

export PATH="$FLUTTER_SDK/bin:$PATH"

flutter doctor -v >> "$LOG_FILE" 2>&1
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo "[ERREUR] flutter doctor a échoué (code: $EXIT_CODE)." >> "$LOG_FILE"
    exit 2
else
    echo "[OK] flutter doctor s’est terminé avec succès." >> "$LOG_FILE"

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
