{
  pkgs,
  lib,
  ...
}: {
  programs.qutebrowser = {
    enable = true;
    package = null;

    loadAutoconfig = true;

    # Noctalia overrides colours via noctalia/colors.py, so only geometry,
    # fonts and behaviour live here.
    settings = {
      fonts = {
        default_family = "JetBrainsMono Nerd Font";
        default_size = "11pt";
        web.family = {
          standard = "JetBrainsMono Nerd Font";
          fixed = "JetBrainsMono Nerd Font Mono";
          sans_serif = "JetBrainsMono Nerd Font";
          serif = "JetBrainsMono Nerd Font";
        };
      };

      content = {
        private_browsing = true;
        cookies = {
          accept = "no-3rdparty";
          store = false;
        };
        autoplay = false;
        canvas_reading = false;
        geolocation = false;
        desktop_capture = false;
        notifications.enabled = false;
        dns_prefetch = false;
        webrtc_ip_handling_policy = "default-public-interface-only";
        headers = {
          referer = "same-domain";
          do_not_track = true;
        };
      };
      colors.webpage = {
        preferred_color_scheme = "dark";
        darkmode = {
          enabled = true;
          policy.images = "never";
        };
      };

      tabs = {
        show = "multiple";
        max_width = 240;
        indicator.width = 2;
        favicons.show = "always";
        title.format = "{index}: {host}";
      };
      statusbar.show = "in-mode";
      completion.height = "30%";
      downloads.position = "bottom";
      scrolling.smooth = true;
      hints.radius = 8;
      url = {
        start_pages = [ "about:blank" ];
        default_page = "about:blank";
      };
    };

    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?q={}";
      aw = "https://wiki.archlinux.org/?search={}";
      nix = "https://search.nixos.org/packages?channel=unstable&query={}";
      gh = "https://github.com/search?q={}&type=repositories";
      yt = "https://www.youtube.com/results?search_query={}";
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go";
    };

    extraConfig = ''
      config.source('noctalia/colors.py')
      c.new_instance_open_target = 'tab-silent'
    '';
  };

  # Noctalia's qutebrowser template reload hook uses `pgrep -f qutebrowser`,
  # which also matches its own command line, so it wrongly spawns a window even
  # when the browser is closed. Replace the cached script with one that only
  # talks to a running instance via its IPC socket, re-seeded every switch.
  home.activation.seedNoctaliaQbReload = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target="$HOME/.local/state/noctalia/community-templates/qutebrowser/reload.sh"
    ${pkgs.coreutils}/bin/mkdir -p "$(${pkgs.coreutils}/bin/dirname "$target")"
    ${pkgs.coreutils}/bin/cat > "$target" <<'NOCTALIA_QB_RELOAD'
#!/bin/sh
COLORS_FILE="''${XDG_CONFIG_HOME:-$HOME/.config}/qutebrowser/noctalia/colors.py"

# Skip if colors.py hasn't changed
[ "$COLORS_FILE" -nt "$0" ] || exit 0
touch "$0"

hash="$(printf '%s' "$USER" | md5sum | cut -d' ' -f1)"
socket="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/qutebrowser/ipc-$hash"

# Presence of the IPC socket is the reliable "qutebrowser is running" check.
[ -S "$socket" ] && qutebrowser :config-source
NOCTALIA_QB_RELOAD
    chmod +x "$target"
  '';
}