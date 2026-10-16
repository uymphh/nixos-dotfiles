{...}: {
  # Use kitty's native `icat` renderer so preview thumbnails occupy real cells
  # instead of painting over the metadata text.
  xdg.configFile."yt-x/config" = {
    force = true;
    text = ''
      CONFIG_ENABLE_PREVIEW=true
      CONFIG_ENABLE_PREVIEW_IMAGES=true
      CONFIG_IMAGE_RENDERER=icat
    '';
  };

  # Monochrome theme: terminal default colours, transparent fzf background.
  xdg.configFile."yt-x/extensions/themes/default.theme" = {
    force = true;
    source = ./yt-x-theme.sh;
  };
}
