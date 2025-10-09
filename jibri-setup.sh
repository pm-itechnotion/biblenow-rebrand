#!/usr/bin/env bash
set -e

# 1. Ensure directory exists
mkdir -p /srv/jibri

# 2. Create the finalize-supabase.sh file with content
cat > /srv/jibri/finalize-supabase.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

: "${SUPABASE_URL:?SUPABASE_URL not set}"
: "${SUPABASE_SERVICE_ROLE_KEY:?SUPABASE_SERVICE_ROLE_KEY not set}"
: "${REGISTER_FUNC_URL:?REGISTER_FUNC_URL not set}"
: "${RECORDINGS_BUCKET:=recordings}"
: "${BIBLENOW_USER_ID:?BIBLENOW_USER_ID not set}"
: "${BIBLENOW_STREAM_ID:?BIBLENOW_STREAM_ID not set}"

REC_DIR="${1:-}"
[ -d "$REC_DIR" ] || { echo "Missing recording dir: $REC_DIR" >&2; exit 1; }

TS=$(date -u +"%Y%m%dT%H%M%SZ")
BASE_PATH="${BIBLENOW_USER_ID}/${BIBLENOW_STREAM_ID}/${TS}"

for f in "$REC_DIR"/*.mp4; do
  [ -e "$f" ] || continue
  fname=$(basename "$f")
  object_path="${BASE_PATH}/${fname}"

  echo "Uploading $fname -> ${RECORDINGS_BUCKET}/${object_path}"

  curl -sS -f -X POST \
    "${SUPABASE_URL}/storage/v1/object/${RECORDINGS_BUCKET}/${object_path}" \
    -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
    -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
    -H "Content-Type: video/mp4" \
    --data-binary @"$f"

  echo "Registering in DB..."
  curl -sS -f -X POST "$REGISTER_FUNC_URL" \
    -H "Content-Type: application/json" \
    --data "{\"user_id\":\"$BIBLENOW_USER_ID\",\"stream_id\":\"$BIBLENOW_STREAM_ID\",\"object_path\":\"$object_path\"}"
done

rm -rf "$REC_DIR"
EOF

# 3. Make it executable
chmod +x /srv/jibri/finalize-supabase.sh

echo "✅ finalize-supabase.sh created successfully at /srv/jibri/finalize-supabase.sh"
