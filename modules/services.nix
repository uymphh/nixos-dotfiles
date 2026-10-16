# System services: flatpak, steam, bluetooth.
# Docker and Tailscale are disabled to cut idle wakeups / background daemons;
# set the flags back to true (or start the units manually) when needed.
{...}: {
  virtualisation.docker.enable = false;
  services.tailscale.enable = false;
  services.flatpak.enable = true;
  programs.steam.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
