#!/usr/bin/env bash

set -e

echo "🚀 Starte Community LibreChat Installer..."

# 1. Original Community Script starten
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/librechat.sh)"

echo "🔧 Patch: MongoDB auf Version 7 setzen..."

# 2. Container/Installationspfad finden
if [ -f /opt/LibreChat/docker-compose.yml ]; then
  cd /opt/LibreChat
elif [ -f /root/LibreChat/docker-compose.yml ]; then
  cd /root/LibreChat
else
  echo "❌ LibreChat Verzeichnis nicht gefunden"
  exit 1
fi

# 3. MongoDB 8 -> 7 fix
sed -i 's/mongo:8/mongo:7/g' docker-compose.yml
sed -i 's/mongo:latest/mongo:7/g' docker-compose.yml

echo "🔄 Container neu starten..."

docker compose down || true
docker compose up -d

echo ""
echo "✅ Fertig!"
echo "🌐 Öffne: http://$(hostname -I | awk '{print $1}'):3080"
