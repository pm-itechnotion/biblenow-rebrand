#!/usr/bin/env bash
set -e

# Path to the interface_config.js file
IC_PATH="${IC_PATH:-/home/itech-h1/Desktop/haresh/biblenow//interface_config.js}"


# Input variables (you can export these before calling the script, or set defaults here)
APP_NAME="${APP_NAME:-BibleNow}"
BRAND_WATERMARK_LINK="${BRAND_WATERMARK_LINK:-https://stream.biblenow.io}"
DEFAULT_BACKGROUND="${DEFAULT_BACKGROUND:-#000000}"
DISPLAY_WELCOME_FOOTER="${DISPLAY_WELCOME_FOOTER:-flase}"
JITSI_WATERMARK_LINK="${JITSI_WATERMARK_LINK:-https://stream.biblenow.io}"
MOBILE_APP_PROMO="${MOBILE_APP_PROMO:-false}"
PROVIDER_NAME="${PROVIDER_NAME:-BibleNow}"
SHOW_BRAND_WATERMARK="${SHOW_BRAND_WATERMARK:-true}"
SHOW_JITSI_WATERMARK="${SHOW_JITSI_WATERMARK:-false}"
SUPPORT_URL="${SUPPORT_URL:-https://stream.biblenow.io}"

# Check that file exists
if [ ! -f "$IC_PATH" ]; then
  echo "Error: interface_config.js not found at $IC_PATH"
  exit 1
fi

# Use sed to replace (or insert) each field inside the interfaceConfig object
# It assumes the file has lines like `APP_NAME: 'SomeValue',`

# A helper for sed replacement
replace_field() {
  local field="$1"
  local newval="$2"
  # Escape forward slashes, single quotes for sed
  local esc=$(printf '%s' "$newval" | sed -e "s/[\/&]/\\\\&/g" -e "s/'/\\'/g")
  # The pattern: optional whitespace, field name, colon, optional whitespace, quote, old val, quote, comma
  # We'll replace the inside string
  sed -i -E "s|(${field}[[:space:]]*:[[:space:]]*')[^']*(')|\1${esc}\2|g" "$IC_PATH"
}

replace_field "APP_NAME" "$APP_NAME"
replace_field "BRAND_WATERMARK_LINK" "$BRAND_WATERMARK_LINK"
replace_field "DEFAULT_BACKGROUND" "$DEFAULT_BACKGROUND"
replace_field "DISPLAY_WELCOME_FOOTER" "$DISPLAY_WELCOME_FOOTER"
replace_field "JITSI_WATERMARK_LINK" "$JITSI_WATERMARK_LINK"
replace_field "MOBILE_APP_PROMO" "$MOBILE_APP_PROMO"
replace_field "PROVIDER_NAME" "$PROVIDER_NAME"
replace_field "SHOW_BRAND_WATERMARK" "$SHOW_BRAND_WATERMARK"
replace_field "SHOW_JITSI_WATERMARK" "$SHOW_JITSI_WATERMARK"
replace_field "SUPPORT_URL" "$SUPPORT_URL"

echo "interface_config.js updated successfully."

