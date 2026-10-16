# Wayland desktop: Hyprland + Noctalia + portals + login manager.
{inputs, config, lib, pkgs, ...}: {
  imports = [
    inputs.noctalia.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.noctalia = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland];
    config.common.default = ["hyprland" "gtk"];
  };
  systemd.user.targets.graphical-session = {
    description = "Graphical session target";
    wantedBy = ["default.target"];
  };
  systemd.user.paths.noctalia-theme = {
    description = "Watch Noctalia theme file";
    wantedBy = ["default.target"];
    pathConfig = {
      PathChanged = "%h/.config/hypr/noctalia.lua";
      Unit = "noctalia-theme-reload.service";
    };
  };
  systemd.user.services.noctalia-theme-reload = {
    description = "Reload Hyprland when the Noctalia theme changes";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${config.programs.hyprland.package}/bin/hyprctl reload";
    };
  };

  systemd.user.services.noctalia = {
    startLimitIntervalSec = 0;
    startLimitBurst = 0;
    serviceConfig = {
      Restart   = lib.mkForce "always";
      RestartSec = "2";
    };
  };
  systemd.user.services.activate-graphical-session = {
    description = "Activate graphical-session.target so xdg-desktop-portal can start";
    unitConfig.Wants = ["graphical-session.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.coreutils}/bin/true";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  services.displayManager.ly.enable = true;
  services.xserver.enable = true;
}
