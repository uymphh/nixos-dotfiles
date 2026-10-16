{
  pkgs,
  lib,
  ...
}: {
  # Do NOT manage kitty.conf itself: Noctalia writes `include themes/noctalia.conf`
  # into it and reloads kitty. A home-manager file is a read-only store symlink,
  # which Noctalia cannot write through. So we only manage user.conf and seed a
  # writable kitty.conf below.
  xdg.configFile."kitty/user.conf".text = ''
    font_family JetBrainsMono Nerd Font
    font_size 12.5
    adjust_line_height 115%

    window_padding_width 16

    cursor_shape beam
    cursor_blink_interval 0
    cursor_trail 3

    scrollback_lines 10000
    remember_window_size no
    enable_audio_bell no
    confirm_os_window_close 0
    copy_on_select yes
    strip_trailing_spaces smart
    mouse_hide_wait 3

    shell_integration enabled

    tab_bar_style powerline
    tab_powerline_style slanted
    active_tab_font_style bold
    inactive_tab_font_style normal
  '';

  # Seed a writable kitty.conf (only if missing) so Noctalia stays free to
  # manage its own include line.
  home.activation.seedKittyConf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    kitty_dir="$HOME/.config/kitty"
    kitty_conf="$kitty_dir/kitty.conf"
    mkdir -p "$kitty_dir"
    if [ ! -e "$kitty_conf" ] && [ ! -L "$kitty_conf" ]; then
      ${pkgs.coreutils}/bin/printf 'include user.conf\ninclude themes/noctalia.conf\n' > "$kitty_conf"
    fi
  '';
}
