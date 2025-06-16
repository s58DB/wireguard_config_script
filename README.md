# WireGuard Client Setup Script

This is a minimal, interactive Bash script for configuring a WireGuard VPN client on Linux systems.

## Features

- Installs WireGuard and necessary dependencies
- Prompts for manual input of all configuration values
- Supports split tunneling or full tunneling
- Optionally sets a custom MTU (or uses system default)
- Saves client `PrivateKey` in the config and `PublicKey` in a separate file
- Generates a standard `wg0.conf` under `/etc/wireguard`
- Optionally starts the VPN connection

## Usage

```bash
chmod +x setup-wireguard.sh
sudo ./setup-wireguard.sh
```

## What You’ll Need

- Client Private and Public Keys (pre-generated or managed manually)
- Server Public Key
- Server Endpoint (hostname/IP and port)
- Allowed IP ranges for split tunneling (optional)

## Output

- `/etc/wireguard/wg0.conf`: WireGuard configuration file
- `/etc/wireguard/client-public.key`: Client's public key (for reference/server-side use)

## Notes

- This script does **not** generate keys. You must supply your own.
- Designed for simple, controlled deployments (e.g., pre-registered clients).
- Tested on Debian/Ubuntu-based systems.

## License

MIT
