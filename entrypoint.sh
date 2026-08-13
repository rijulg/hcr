#!/bin/sh
set -eu

: "${TS_HOSTNAME:?must be set to the node name on the tailnet}"
: "${TS_AUTHKEY:?must be set to a tailscale auth key}"

tailscaled --statedir=/var/lib/tailscale --tun=userspace-networking &

for _ in $(seq 30); do
  [ -S /var/run/tailscale/tailscaled.sock ] && break
  sleep 1
done

tailscale up --hostname="$TS_HOSTNAME" --authkey="$TS_AUTHKEY"
tailscale serve --bg --https=443 http://127.0.0.1:5000

exec "$@"
