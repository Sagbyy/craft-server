#!/bin/bash
set -euo pipefail

#  Dépendances
for pkg in curl jq; do
  if ! command -v "$pkg" >/dev/null; then
    echo "Installing $pkg..." >&2
    sudo apt-get update && sudo apt-get install -y "$pkg"
  fi
done

# Variables
API_URL="https://calendrier.api.gouv.fr/jours-feries/metropole.json"
TODAY=$(date +%F)

#  Récup du JSON
json=$(curl -sSf "$API_URL") || {
  echo "Error: cannot fetch holidays from $API_URL" >&2
  exit 1
}

# recherche du prochain jour férié
#    - to_entries : transforme {date:nom,...} en [{key,date, value:nom},...]
#    - select(.key > TODAY) : ne garde que les dates après aujourd'hui
#    - sort_by(.key) : tri chronologique
#    - .[0] : le premier (le plus proche)
#    - "\(.key) \(.value)" : format “YYYY-MM-DD Nom”
next=$(echo "$json" | jq -r --arg today "$TODAY" '
  to_entries
  | map(select(.key > $today))
  | sort_by(.key)
  | .[0]
  | "\(.key) \(.value)"
')

# 5) Vérification et affichage
if [[ -z "$next" || "$next" == "null null" ]]; then
  echo "No upcoming holiday found." >&2
  exit 1
fi

echo "Next holiday: $next"
exit 0

