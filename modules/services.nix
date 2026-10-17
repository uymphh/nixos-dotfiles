# System services. Kept to the bare minimum: only Bluetooth is on. Docker,
# Tailscale, Flatpak and Steam are intentionally disabled/absent to avoid
# background daemons and idle wakeups.
{...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
