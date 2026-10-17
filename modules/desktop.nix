# Wayland desktop: Sway + wlroots portals + ly login manager.
# Deliberately minimal: no compositor shell, no GUI daemons beyond what a
# Sway session needs (the bar + notifications live in home-manager).
#
# Note on the "proprietary GPU drivers are not supported" warning Sway prints:
# this machine is a hybrid Intel + NVIDIA laptop. Sway/wlroots runs on the
# Intel iGPU (Mesa, open source); the NVIDIA dGPU is kept purely for on-demand
# offload (see modules/hardware/nvidia.nix, hardware.nvidia.prime.offload).
# wlroots still detects the loaded nvidia module and warns, but it is harmless
# here because Sway never drives the NVIDIA adapter directly.
{pkgs, ...}: {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr];
    config.common.default = ["wlr" "gtk"];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  # ly is a tiny TUI login manager -- fits the CLI-first theme.
  services.displayManager.ly.enable = true;

  # The X server is never started (Sway is Wayland-only) but the option is kept
  # on so the NVIDIA driver wiring and XWayland helper stay intact.
  services.xserver.enable = true;
}
