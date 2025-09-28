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
if pacman -Q firefox &>/dev/null; then
  echo "Apparmor installed already"
else
  pacman -S apparmor
fi

echo "==> Enabling AppArmor service..."
systemctl daemon-reload
systemctl enable apparmor
systemctl restart apparmor

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

# firefox profile
profile /usr/lib/firefox/firefox{,*[^s][^h]} {
  # allow the wrapper script (if /usr/bin/firefox is a shell script that then execs /usr/lib/firefox/firefox)
  /usr/bin/firefox ix,

  # abstractions to reuse common rules
  # base files, fonts, sound, X, DBus etc.
  # these include things like /etc/ssl, /usr/lib, /usr/share etc.
  # Might have to have abstraction files on your system
  # For example:
  #   <abstractions/base>
  #   <abstractions/x11>
  #   <abstractions/dbus-strict>
  #   <abstractions/pulseaudio>
  #   <abstractions/wayland>  (if you use wayland)
  #   <abstractions/mesa>     (for GPU / OpenGL / WebRender)
  # As needed, you include them:
  #include <abstractions/base>
  #include <abstractions/nameservice>
  #include <abstractions/dbus-strict>
  #include <abstractions/xdg-download>
  #include <abstractions/xdg-documents>
  #include <abstractions/user-tmp>

  # Required file reads
  /usr/lib/firefox/** mr,    # read, map (executable code), etc
  /usr/lib/*/firefox/** mr,
  /usr/share/firefox/** r,
  /usr/share/*/firefox/** r,
  /etc/fonts/** r,
  /etc/ssl/** r,
  /etc/pki/** r,
  /usr/share/ca-certificates/** r,

  # profile (user data) and cache in home
  owner @{HOME}/.mozilla/** rwk,
  owner @{HOME}/Downloads/** rw,
  owner @{HOME}/.cache/mozilla/** rwk,

  # GPU / DRM / Mesa etc
  /dev/dri/* rw,
  /dev/nvidia* rw,            # if using NVIDIA
  /dev/shm/** rw,
  /dev/urandom r,
  /dev/random r,

  # sound
  /dev/snd/** rw,

  # X11 / Wayland / display server connections
  unix (bind, connect, send, receive) type=stream addr=unix-abstract peer=(label=unconfined),
  # Or more restrictive depending on how your setup is

  # Network
  network inet stream,
  network inet6 stream,
  network udp dgram,           # if needed (e.g. DNS queries)

  # Capabilities (limit these as much as possible)
  capability net_bind_service,
  capability setgid,
  capability setuid,           # only if needed

  # DBus access (for media keys, notifications, etc)
  dbus (send)
    bus=session
    interface=org.freedesktop.DBus
    path=/org/freedesktop/DBus
    peer=(label=unconfined);

  # MPRIS (media control)
  dbus (send, receive)
    bus=session
    interface=org.freedesktop.DBus.Properties
    path=/org/mpris/MediaPlayer2
    peer=(label=unconfined);
  dbus (bind)
    bus=session
    name=org.mpris.MediaPlayer2.firefox;

  # mmap of certain libraries (e.g. DRM / Widevine)
  owner @{HOME}/.mozilla/**/libwidevinecdm.so mr,

  # Allow read access to GPU device sysfs items (if required)
  /sys/devices/pci*/**/config r,
  /sys/devices/pci*/**/revision r,
  /sys/class/drm/** r,

  # Allow save of shader cache etc (if used)
  owner @{HOME}/.cache/mesa_shader_cache/** rw,

  # Logging / deny rest
  deny /** wklx,
  audit deny /** wklx,
}

EOF

echo "==> Reloading AppArmor profile..."
apparmor_parser -r "$PROFILE_PATH"

echo "==> Enforcing profile..."
aa-enforce usr.bin.firefox

echo "✅ Firefox AppArmor profile configured and enforced."

echo "➡️ Reboot your system to ensure AppArmor is fully active (with kernel boot parameters)."
