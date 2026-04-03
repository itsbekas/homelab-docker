#!/bin/bash
#
# Extract user-provided secrets from the running server.
# Run this ON THE SERVER to get values for ansible/vars/vault.yml.
#
# Note: *arr API keys and the Donetick JWT secret are NOT here --
# Ansible auto-extracts those from running services.
#
# Usage: ./scripts/extract-secrets.sh

set -euo pipefail

DOCKER_DIR="${DOCKER_DIR:-/opt/docker}"

red()   { printf '\033[0;31m%s\033[0m\n' "$1"; }
green() { printf '\033[0;32m%s\033[0m\n' "$1"; }
dim()   { printf '\033[0;90m%s\033[0m\n' "$1"; }

read_env_var() {
    local file="$1" var="$2"
    if [[ -f "$file" ]]; then
        grep "^${var}=" "$file" 2>/dev/null | head -1 | cut -d'=' -f2- | sed 's/^["\x27]//;s/["\x27]$//' || echo ""
    fi
}

echo "============================================"
echo "  Homelab secret extraction"
echo "============================================"
echo ""
dim "Reading from: ${DOCKER_DIR}"
dim "*arr API keys and Donetick JWT are auto-extracted by Ansible."
echo ""

vite_donetick_url=$(read_env_var "${DOCKER_DIR}/homepage/.env" "VITE_DONETICK_URL")
vite_donetick_key=$(read_env_var "${DOCKER_DIR}/homepage/.env" "VITE_DONETICK_API_KEY")
vite_todoist=$(read_env_var "${DOCKER_DIR}/homepage/.env" "VITE_TODOIST_API_TOKEN")

mqtt_user=$(read_env_var "${DOCKER_DIR}/telegraf/.env" "MQTT_USERNAME")
mqtt_pass=$(read_env_var "${DOCKER_DIR}/telegraf/.env" "MQTT_PASSWORD")
mqtt_client=$(read_env_var "${DOCKER_DIR}/telegraf/.env" "MQTT_CLIENT_ID")

gh_user=$(read_env_var "${DOCKER_DIR}/util-api/.env" "GH_USERNAME")
gh_pat=$(read_env_var "${DOCKER_DIR}/util-api/.env" "GH_PAT")

qb_user=$(read_env_var "${DOCKER_DIR}/cross-seed/.env" "QBITTORRENT_USER")
qb_pass=$(read_env_var "${DOCKER_DIR}/cross-seed/.env" "QBITTORRENT_PASSWORD")

echo "Paste this into ansible/vars/vault.yml:"
echo "----------------------------------------"
echo ""
cat <<EOF
---
vault_service_envs:
  homepage:
    VITE_DONETICK_URL: "${vite_donetick_url:-CHANGEME}"
    VITE_DONETICK_API_KEY: "${vite_donetick_key:-CHANGEME}"
    VITE_TODOIST_API_TOKEN: "${vite_todoist:-CHANGEME}"
  telegraf:
    MQTT_USERNAME: "${mqtt_user:-CHANGEME}"
    MQTT_PASSWORD: "${mqtt_pass:-CHANGEME}"
    MQTT_CLIENT_ID: "${mqtt_client:-telegraf-mosquitto}"
  util-api:
    GH_USERNAME: "${gh_user:-CHANGEME}"
    GH_PAT: "${gh_pat:-CHANGEME}"

vault_qbittorrent_user: "${qb_user:-CHANGEME}"
vault_qbittorrent_password: "${qb_pass:-CHANGEME}"
EOF

echo ""
echo "----------------------------------------"

missing=0
for var in vite_donetick_url vite_donetick_key vite_todoist \
           mqtt_user mqtt_pass gh_user gh_pat qb_user qb_pass; do
    val="${!var}"
    if [[ -z "$val" ]]; then
        red "  MISSING: ${var} -- fill this in manually"
        missing=$((missing + 1))
    fi
done

if [[ $missing -eq 0 ]]; then
    green "All secrets found."
else
    echo ""
    dim "For missing values, check the relevant service's UI or config."
fi

echo ""
dim "After filling in vault.yml, encrypt it:"
dim "  cd ansible && ansible-vault encrypt vars/vault.yml"
