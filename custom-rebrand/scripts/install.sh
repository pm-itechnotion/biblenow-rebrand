#!/bin/bash
# rexxu

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error

# === Variables ===
JITSI_REPO="https://github.com/jitsi/docker-jitsi-meet.git"
JITSI_DIR="/home/docker-jitsi-meet"
CFG_DIR="/home"
IMG_DIR="$CFG_DIR/images"

REBRAND_SVG_URL="https://d1p1y5pyxk2k6i.cloudfront.net/4idvd%2Fpreview%2F71191062%2Fmain_large.png?response-content-disposition=inline%3Bfilename%3D%22main_large.png%22%3B&response-content-type=&Expires=1758701866&Signature=WAuV4sluNEZoONHk14dTeu2r2OhrNliKyN5T4mAZnuqmxsPILxHCwW2b0~QZcynugjtAf~hsGN7NUnERR5hwcGB5NOHPoaNtQ04bz6pE~JQro3GT8YZuqWMCFnYM6j76DTaOX4zlpXP8dlm2fF2nsMulLMXQy8AmP5ewejYTcbiCkrfK9jHjBwt15NNWKcObKKPQ1uPG79QsHi3Dgrlqyj8vERV~nuZx8GOPLT9rTm4Os7OsmVEtptDjC~QF21zAszFGmBQi7O9aqZq4~95Xllry3trfec-SGyA-Yk1grBovgA4y~RxuirXAwDQHXzmrzW-wGDqI5gBQM~C2jpqyxg__&Key-Pair-Id=APKAJT5WQLLEOADKLHBQ"
REBRAND_PNG_URL="https://i.ibb.co/j9yRvMf4/main_large.png"

# === Download other images dynamically from OTHER_URLS ===
OTHER_URLS=(
https://itech-apk-files.s3.us-east-2.amazonaws.com/apple-touch-icon.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/app-store-badge.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/avatar.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/btn_google_signin_dark_normal.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/calendar.svg-apkver-1-date-25-09-2025.svg
https://itech-apk-files.s3.us-east-2.amazonaws.com/chromeLogo.svg-apkver-1-date-25-09-2025.svg
https://itech-apk-files.s3.us-east-2.amazonaws.com/downloadLocalRecording.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/dropboxLogo_square.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/favicon.svg-apkver-1-date-25-09-2025.svg
https://itech-apk-files.s3.us-east-2.amazonaws.com/f-droid-badge.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/flags.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/flags%402x.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/GIPHY_icon.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/GIPHY_logo.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/googleLogo.svg-apkver-1-date-25-09-2025.svg
https://itech-apk-files.s3.us-east-2.amazonaws.com/google-play-badge.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/icon-cloud.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/icon-info.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazo``naws.com/icon-users.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/jitsilogo.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/logo-deep-linking.png-apkver-1-date-25-09-2025.png
https://itech-apk-files.s3.us-east-2.amazonaws.com/microsoftLogo.svg-apkver-1-date-25-09-2025.svg
https://itech-apk-files.s3.us-east-2.amazonaws.com/share-audio.gif-apkver-1-date-25-09-2025.gif
https://itech-apk-files.s3.us-east-2.amazonaws.com/watermark.svg-apkver-1-date-25-09-2025.svg
https://itech-apk-files.s3.us-east-2.amazonaws.com/welcome-background.png-apkver-1-date-25-09-2025.png
)

# === Root check ===
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root (sudo $0)"
  exit 1
fi

# === Clone docker-jitsi-meet ===
if [[ ! -d "$JITSI_DIR" ]]; then
  git clone "$JITSI_REPO" "$JITSI_DIR"
fi

cd "$JITSI_DIR"

# === Setup env ===
echo "Setting up environment..."
cp -n env.example .env
./gen-passwords.sh

# clean up old images
echo "Clearing old images in $IMG_DIR..."
rm -rf "$IMG_DIR"/*
mkdir -p "$IMG_DIR"

# === Create config directories ===
mkdir -p "$CFG_DIR"/{web,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}
mkdir -p "$IMG_DIR"

# for url in "${OTHER_URLS[@]}"; do
#     filename=$(basename "$url")
#     clean_name=$(echo "$filename" | sed -E 's/-apkver-[0-9]+-date-[0-9-]+//')

#     # Remove any conflicting directory
#     if [[ -d "$IMG_DIR/$clean_name" ]]; then
#         rm -rf "$IMG_DIR/$clean_name"
#     fi

#     curl -L "$url" -o "$IMG_DIR/$clean_name"
#     echo "Downloaded $clean_name"
# done

CFG_DIR="/home"
DEST_DIR="$CFG_DIR/images"
IMG_DIR="$DEST_DIR"

echo "Downloading images..."
for url in "${OTHER_URLS[@]}"; do
    filename=$(basename "$url")

    # Clean name: strip -apkver and ensure one extension
    clean_name=$(echo "$filename" | sed -E 's/-apkver[^.]*//; s/(\.(png|svg|gif)).*/\1/')

    curl -L "$url" -o "$IMG_DIR/$clean_name"
    echo "Downloaded $clean_name"
done


echo "Destination directory for images: $IMG_DIR"

# echo "Downloading Branding Images..."
# curl -L "$REBRAND_SVG_URL" -o "$IMG_DIR/watermark.svg"
# curl -L "$REBRAND_SVG_URL" -o "$IMG_DIR/favicon.svg"
# curl -L "$REBRAND_PNG_URL" -o "$IMG_DIR/logo-deep-linking-mobile.png"
# curl -L "$REBRAND_PNG_URL" -o "$IMG_DIR/logo-deep-linking.png"
# curl -L "$REBRAND_PNG_URL" -o "$IMG_DIR/apple-touch-icon.png"


echo "✅ All images downloaded into $IMG_DIR"

# rebrand.sh content to update docker-compose.yml

DOCKER_COMPOSE_FILE="/home/docker-jitsi-meet/docker-compose.yml"
DEST_DIR="$CFG_DIR/web/images/"

# Verify DEST_DIR exists
if [[ ! -d "$DEST_DIR" ]]; then
  echo "DEST_DIR $DEST_DIR does not exist. Please create/download images first."
  exit 1
fi

# Backup docker-compose.yml
cp "$DOCKER_COMPOSE_FILE" "${DOCKER_COMPOSE_FILE}.bak"
echo "Backup created at ${DOCKER_COMPOSE_FILE}.bak"

# Prepare volume mounts for images
IMAGE_VOLUMES=$(cat <<EOF
            - $DEST_DIR:/usr/share/jitsi-meet/images/:Z
EOF
)

# Insert image volumes after the first volumes: block in web service
awk -v vols="$IMAGE_VOLUMES" '
  $1=="volumes:" && f==0 {print; print vols; f=1; next} 
  {print}
' "$DOCKER_COMPOSE_FILE" > "${DOCKER_COMPOSE_FILE}.tmp"

# Replace original file
mv "${DOCKER_COMPOSE_FILE}.tmp" "$DOCKER_COMPOSE_FILE"

echo "docker-compose.yml updated with custom image volumes."


# === Copy default config files from running containers ===
if [[ ! -x "$(command -v docker)" ]]; then
  echo "Error: docker is not installed." >&2
  exit 1
fi

CFG_DIR="/home"

sudo docker cp docker-jitsi-meet-web-1:/usr/share/jitsi-meet/title.html $CFG_DIR
# Copy config.js from /config
docker cp docker-jitsi-meet-web-1:/config/config.js $CFG_DIR
# Copy interface_config.js (if present) from /config
docker cp docker-jitsi-meet-web-1:/config/interface_config.js $CFG_DIR