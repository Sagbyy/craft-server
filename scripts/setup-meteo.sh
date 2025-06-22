#!/bin/bash

# Initialize environment variables
set -a
source ../.env
set +a

# Curl the API
$RESPONSE=$(curl https://api.openweathermap.org/data/2.5/weather?lat=48.849145391082985&lon=2.3899166880099876&units=metric&appid=${OPENWEATHER_API_KEY})

# Parse the response
$AVERAGE_TEMP=$(echo $RESPONSE | jq .main.temp)
$MOOD=$(echo $RESPONSE | jq .weather[0].main)

# Print the average temperature
echo "Hello $(whoami) ! We are $(date +%A) and the average temperature is $AVERAGE_TEMP°C. The mood is $MOOD." > /etc/motd