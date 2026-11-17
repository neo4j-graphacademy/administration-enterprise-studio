#!/usr/bin/env bash
# Runs once when the Codespace is created. Pre-pulls the images and writes the
# Studio address to STUDIO_LINK.txt, which every new terminal prints.
set -euo pipefail

command -v jq >/dev/null || sudo apt-get install -y jq

until docker info >/dev/null 2>&1; do sleep 1; done
docker compose -f cluster/docker-compose.yml pull
docker pull neo4j/enterprise-studio:latest

if [ -n "${CODESPACE_NAME:-}" ]; then
  URL="https://${CODESPACE_NAME}-8080.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
else
  URL="http://localhost:8080"
fi

LINK_FILE="$PWD/STUDIO_LINK.txt"
printf 'Neo4j Enterprise Studio (after you start it, sign in as neo4j / neo4j-password):\n%s\n' "$URL" > "$LINK_FILE"

for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  grep -q STUDIO_LINK "$rc" 2>/dev/null || \
    echo "echo; cat \"$LINK_FILE\"; echo" >> "$rc"
done
