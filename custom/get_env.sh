#!/bin/sh

# Install required packages (run this only once, not as part of the script)
apk add --no-cache jq curl

# Retrieve the secrets
SECRETS=$(curl -s -H "X-Vault-Token: $VAULT_TOKEN" "$VAULT_ADDR/v1/kv/data/homepage")

# Check if the retrieval was successful
if [ $? -ne 0 ]; then
    echo "Failed to retrieve secrets from Vault."
    exit 1
fi

# Define the variables
VARS="
HOMEPAGE_VAR_PVE_URL
HOMEPAGE_VAR_PVE_USERNAME
HOMEPAGE_VAR_PVE_PASSWORD
HOMEPAGE_VAR_TAILSCALE_URL
HOMEPAGE_VAR_IMMICH_URL
HOMEPAGE_VAR_IMMICH_API_KEY
HOMEPAGE_VAR_ADGUARD_URL
HOMEPAGE_VAR_ADGUARD_USERNAME
HOMEPAGE_VAR_ADGUARD_PASSWORD
HOMEPAGE_VAR_DELUGE_URL
HOMEPAGE_VAR_DELUGE_PASSWORD
HOMEPAGE_VAR_SPEEDTEST_URL
HOMEPAGE_VAR_CALENDAR_TIMEZONE
HOMEPAGE_VAR_CALENDAR_ICS
HOMEPAGE_VAR_OVERSEERR_API_KEY
HOMEPAGE_VAR_OVERSEERR_URL
HOMEPAGE_VAR_PLEX_PUBLIC_URL
HOMEPAGE_VAR_PLEX_URL
HOMEPAGE_VAR_PLEX_API_KEY
HOMEPAGE_VAR_WEATHER_LOCATION_LABEL
HOMEPAGE_VAR_WEATHER_LATITUDE
HOMEPAGE_VAR_WEATHER_LONGITUDE
HOMEPAGE_VAR_WEATHER_PROVIDER
HOMEPAGE_VAR_WEATHER_API_KEY
HOMEPAGE_VAR_WEATHER_UNITS
HOMEPAGE_VAR_HOMEASSISTANT_URL
HOMEPAGE_VAR_HOMEASSISTANT_API_KEY
"

# Extract values and export them
for key in $VARS; do
    # Extract the value using jq
    value=$(echo "$SECRETS" | jq -r ".data.data.$key")

    # Export the variable and append to ~/.profile
    if [ -n "$value" ]; then
#        echo "$key=$value"
        echo "export $key=\"$value\"" >> ~/.profile
    fi
done