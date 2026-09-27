#!/usr/bin/env bash
set -euo pipefail
repo=isaiahpettingill/hataroid
backup="${HOME}/hataroid-signing"
keystore="${backup}/hataroid-release.p12"
password_file="${backup}/password"
for tool in gh keytool openssl base64; do
  command -v "$tool" >/dev/null || { echo "Missing $tool" >&2; exit 1; }
done
gh auth status >/dev/null
umask 077
mkdir -p "$backup"
if [[ -e "$keystore" && ! -s "$password_file" || ! -e "$keystore" && -e "$password_file" ]]; then
  echo "Incomplete signing backup at $backup" >&2
  exit 1
fi
if [[ ! -e "$keystore" ]]; then
  password=$(openssl rand -hex 24)
  keytool -genkeypair -noprompt -storetype PKCS12 -keystore "$keystore" -alias hataroid -keyalg RSA -keysize 3072 -validity 10000 -dname 'CN=Hataroid, O=Hataroid' -storepass "$password" -keypass "$password"
  printf '%s\n' "$password" > "$password_file"
  echo "Created signing backup at $backup; keep both files together."
fi
password=$(cat "$password_file")
temp_env=$(mktemp)
trap 'rm -f "$temp_env"' EXIT
{
  printf 'HATAROID_KEYSTORE_B64=%s\n' "$(base64 < "$keystore" | tr -d '\n')"
  printf 'HATAROID_STORE_PASSWORD=%s\n' "$password"
  printf 'HATAROID_KEY_ALIAS=hataroid\n'
  printf 'HATAROID_KEY_PASSWORD=%s\n' "$password"
} > "$temp_env"
gh secret set --repo "$repo" -f "$temp_env"
echo 'Private Actions signing secrets configured.'
gh workflow run android.yml --repo "$repo" --ref master
echo "Release build started: https://github.com/$repo/actions/workflows/android.yml"
