{
  pkgs,
  lib,
  config,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;

    config = {
      terminal = "foot";
      menu = "${pkgs.fuzzel}/bin/fuzzel";
      modifier = "Mod4";

      fonts = {
        names = ["JetBrainsMono Nerd Font"];
        size = 11.0;
      };

      gaps = {
        inner = 8;
        outer = 12;
        smartGaps = "off";
        smartBorders = "off";
      };

      window = {
        titlebar = false;
        border = 2;
        hideEdgeBorders = "none";
      };

      floating = {
        titlebar = false;
        border = 2;
      };

      colors = {
        focused = {
          border = "#ffffff";
          background = "#000000";
          text = "#ffffff";
          indicator = "#ffffff";
          childBorder = "#ffffff";
        };
        focusedInactive = {
          border = "#444444";
          background = "#000000";
          text = "#bbbbbb";
          indicator = "#444444";
          childBorder = "#444444";
        };
        unfocused = {
          border = "#2a2a2a";
          background = "#000000";
          text = "#777777";
          indicator = "#2a2a2a";
          childBorder = "#2a2a2a";
        };
        urgent = {
          border = "#ffffff";
          background = "#ffffff";
          text = "#000000";
          indicator = "#ffffff";
          childBorder = "#ffffff";
        };
        placeholder = {
          border = "#000000";
          childBorder = "#000000";
          background = "#000000";
          text = "#bbbbbb";
          indicator = "#000000";
        };
      };

      input = {
        "*" = {
          xkb_layout = "us";
          xkb_options = "caps:escape";
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled";
        };
      };

      output."*".bg = "#000000 solid_color";

      bars = [
        {
          position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-default.toml";
          fonts = {
            names = ["JetBrainsMono Nerd Font"];
            size = 10.0;
          };
          trayOutput = "*";
          workspaceButtons = true;
          colors = {
            background = "#000000";
            statusline = "#ffffff";
            separator = "#333333";
            focusedWorkspace = {
              border = "#ffffff";
              background = "#ffffff";
              text = "#000000";
            };
            activeWorkspace = {
              border = "#333333";
              background = "#333333";
              text = "#ffffff";
            };
            inactiveWorkspace = {
              border = "#000000";
              background = "#000000";
              text = "#777777";
            };
            urgentWorkspace = {
              border = "#ffffff";
              background = "#ffffff";
              text = "#000000";
            };
          };
        }
      ];

      keybindings = lib.mkOptionDefault {
        "Mod4+space" = "exec ${pkgs.fuzzel}/bin/fuzzel";
        "Mod4+Shift+w" = "exec ${pkgs.brave-origin}/bin/brave-origin";
        "Mod4+q" = "kill";
        "Mod4+e" = "exec foot -e yazi";
        "Mod4+x" = "exec ${pkgs.swaylock}/bin/swaylock";
        "Mod4+Shift+s" = ''exec grim -g "$(slurp)" - | wl-copy'';
        "Print" = "exec grim - | wl-copy";
      };
    };

    extraConfig = ''
      # Media / brightness keys: work while the screen is locked, no repeat.
      bindsym --locked --no-repeat XF86AudioRaiseVolume exec pamixer -i 5
      bindsym --locked --no-repeat XF86AudioLowerVolume exec pamixer -d 5
      bindsym --locked --no-repeat XF86AudioMute exec pamixer -t
      bindsym --locked --no-repeat XF86MonBrightnessUp exec brightnessctl set +10%
      bindsym --locked --no-repeat XF86MonBrightnessDown exec brightnessctl set 10%-
    '';
  };

  programs.i3status-rust = {
    enable = true;
    bars.default = {
      icons = "material-nf";
      theme = "plain";
      blocks = [
        {
          block = "cpu";
          interval = 1;
          format = " $icon $utilization ";
        }
        {
          block = "memory";
          format = " $icon $mem_total_used_percents ";
          format_alt = " $icon $swap_used_percents ";
        }
        {
          block = "net";
          format = " $icon {$ssid $signal_strength|wired} ";
        }
        {
          block = "battery";
          format = " $icon $percentage ";
        }
        {
          block = "sound";
          format = " $icon $volume ";
          click = [
            {
              button = "left";
              cmd = "pamixer -t";
            }
          ];
        }
        {
          block = "time";
          interval = 30;
          format = " $icon $timestamp.datetime(f:'%a %d %b %R') ";
        }
      ];
    };
  };

  services.mako = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 10";
      "background-color" = "#000000";
      "text-color" = "#ffffff";
      "border-color" = "#444444";
      "border-radius" = 8;
      "border-size" = 2;
      "default-timeout" = 5000;
      "max-visible" = 5;
      anchor = "top-right";
      margin = 10;
    };
  };
}
