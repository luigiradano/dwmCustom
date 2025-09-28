#!/bin/bash

set -e

USER="luigi"
PROFILE_PATH="/etc/apparmor.d/usr.bin.firefox"

# Ensure root
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (e.g., sudo $0)"
  exit 1
fi

echo "==> Installing AppArmor and Firefox tools..."
pacman -Sy apparmor

echo "==> Enabling AppArmor service..."
systemctl enable apparmor
systemctl start apparmor

# Enable AppArmor in kernel parameters (for GRUB or systemd-boot)
if grep -q '^GRUB_CMDLINE_LINUX=' /etc/default/grub; then
  echo "==> Configuring GRUB to enable AppArmor..."
  sudo sed -i 's|\(^GRUB_CMDLINE_LINUX=".*\)"|\1 apparmor=1 security=apparmor"|' /etc/default/grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg
else
  echo "⚠️ You need to manually add 'apparmor=1 security=apparmor' to your kernel boot parameters."
  echo "   If you use systemd-boot, edit /boot/loader/entries/*.conf and append to 'options'."
fi

echo "==> Writing AppArmor profile to: $PROFILE_PATH"

cat <<'EOF' >"$PROFILE_PATH"
#include <tunables/global>

profile usr.bin.firefox {
  # Firefox main binary
  /usr/bin/firefox ix,

  # Common read access
  /usr/** r,
  /etc/** r,

  # Write access to profile & cache
  owner @{HOME}/.mozilla/** rwk,
  owner @{HOME}/.cache/mozilla/** rwk,

  # Access to dev (e.g. sound)
  /dev/** rw,

  # Shared memory
  /dev/shm/** rw,

  # Allow X11 access
  unix (connect, send, receive) type=stream addr=none peer=unconfined,

  # Networking
  network inet stream,
  network inet6 stream,

  # Capabilities
  capability net_bind_service,
  capability sys_chroot,
  capability setuid,
  capability setgid,

  # Deny everything else
  deny /** wklx,

  # Audit denials
  audit deny /** wklx,
}
EOF

echo "==> Reloading AppArmor profile..."
apparmor_parser -r "$PROFILE_PATH"

echo "==> Enforcing profile..."
aa-enforce usr.bin.firefox

echo "✅ Firefox AppArmor profile configured and enforced."

echo "➡️ Reboot your system to ensure AppArmor is fully active (with kernel boot parameters)."
