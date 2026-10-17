{...}: {
  # dillo-plus reads plain key=value settings from ~/.dillo-plus/dillorc.
  home.file.".dillo-plus/dillorc".text = ''
    # Managed by NixOS (home/dillo.nix).

    # Start page & default search (DuckDuckGo lite).
    start_page="https://lite.duckduckgo.com/lite/"
    home="https://lite.duckduckgo.com/lite/"
    search_url="dd DuckDuckGo https://lite.duckduckgo.com/lite/?q=%s"

    # Fonts
    font_sans_serif="JetBrainsMono Nerd Font"
    font_serif="JetBrainsMono Nerd Font"
    font_monospace="JetBrainsMono Nerd Font"
    font_factor=1.1

    # Black & white chrome (0xRRGGBB avoids clashing with the comment char).
    ui_fg_color=0xffffff
    ui_main_bg_color=0x000000
    ui_text_bg_color=0x000000
    ui_selection_color=0xffffff
    ui_button_highlight_color=0x888888
    ui_tab_active_bg_color=0xffffff
    ui_tab_active_fg_color=0x000000
    ui_tab_bg_color=0x000000
  '';
}
