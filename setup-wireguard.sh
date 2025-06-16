#!/bin/bash

# Ensure script is run as root
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run this script as root (sudo)."
  exit 1
fi

echo "Installing WireGuard..."
apt update && apt install -y wireguard resolvconf || {
  echo "Installation failed."
  exit 1
}

WG_DIR="/etc/wireguard"
WG_CONF="$WG_DIR/wg0.conf"

echo ""
echo "WireGuard Client Configuration:"
read -p "Client PrivateKey: " PRIVATE_KEY
read -p "Client PublicKey: " PUBLIC_KEY
read -p "Client IP address (e.g. 10.0.0.2/32): " CLIENT_IP
read -p "DNS server (e.g. 1.1.1.1): " DNS_SERVER
read -p "MTU (leave empty to use system default): " MTU
read -p "Server PublicKey: " SERVER_PUBKEY
read -p "Server Endpoint (e.g. vpn.example.com:51820): " ENDPOINT

echo ""
read -p "Enable split tunneling? (y/n): " SPLIT

if [[ "$SPLIT" =~ ^[Yy]$ ]]; then
  read -p "Enter Allowed IPs (comma-separated, e.g. 10.0.0.0/24,192.168.100.0/24): " ALLOWED_IPS
else
  ALLOWED_IPS="0.0.0.0/0"
fi

mkdir -p "$WG_DIR"
chmod 700 "$WG_DIR"

{
echo "[Interface]"
echo "PrivateKey = $PRIVATE_KEY"
echo "Address = $CLIENT_IP"
echo "DNS = $DNS_SERVER"
if [[ -n "$MTU" ]]; then
  echo "MTU = $MTU"
fi
echo ""
echo "[Peer]"
echo "PublicKey = $SERVER_PUBKEY"
echo "Endpoint = $ENDPOINT"
echo "AllowedIPs = $ALLOWED_IPS"
echo "PersistentKeepalive = 25"
} > "$WG_CONF"

chmod 600 "$WG_CONF"

echo "$PUBLIC_KEY" > "$WG_DIR/client-public.key"
chmod 600 "$WG_DIR/client-public.key"

echo ""
echo "Configuration saved to: $WG_CONF"
echo "Client public key saved to: $WG_DIR/client-public.key"
if [[ -z "$MTU" ]]; then
  echo "MTU not set. Default system MTU will be used."
fi

read -p "Start VPN now? (y/n): " START_NOW
if [[ "$START_NOW" =~ ^[Yy]$ ]]; then
  wg-quick up wg0 && echo "VPN started successfully." || echo "Failed to start VPN."
else
  echo "You can start the VPN manually with: sudo wg-quick up wg0"
fi
