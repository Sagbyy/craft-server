#!/bin/bash

# Initialize environment variables
set -a
source "$(dirname "$0")/../.env"
set +a

# Check if API key is set
if [ -z "$OPENWEATHER_API_KEY" ]; then
    echo "Error: OPENWEATHER_API_KEY environment variable is not set"
    exit 1
fi

# Curl the API
RESPONSE=$(curl -s "https://api.openweathermap.org/data/2.5/weather?lat=48.849145391082985&lon=2.3899166880099876&units=metric&appid=${OPENWEATHER_API_KEY}")

# Check if curl was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch weather data"
    exit 1
fi

# Check if response contains error
if echo "$RESPONSE" | jq -e '.cod' | grep -q "401\|400\|404"; then
    echo "Error: API returned an error: $(echo "$RESPONSE" | jq -r '.message // .cod')"
    exit 1
fi

# Parse the response
AVERAGE_TEMP=$(echo "$RESPONSE" | jq -r '.main.temp')
MOOD=$(echo "$RESPONSE" | jq -r '.weather[0].main')

# Check if parsing was successful
if [ -z "$AVERAGE_TEMP" ] || [ -z "$MOOD" ]; then
    echo "Error: Failed to parse weather data"
    exit 1
fi

# Print the average temperature
echo "Hello $(whoami) ! We are $(date +%A) and the average temperature is ${AVERAGE_TEMP}°C. The mood is ${MOOD}." > /etc/motd