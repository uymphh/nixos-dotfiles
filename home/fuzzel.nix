{pkgs, ...}: {
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=11";
        icons-enabled = "no";
        terminal = "${pkgs.foot}/bin/foot";
        layer = "overlay";
        lines = 12;
        width = 34;
        horizontal-pad = 12;
        vertical-pad = 12;
        inner-pad = 0;
      };

      border = {
        width = 2;
        radius = 0;
        color = "ffffffff";
      };

      colors = {
        background = "000000ff";
        text = "ffffffff";
        prompt = "ffffffff";
        input = "ffffffff";
        match = "ffffffff";
        selection = "ffffffff";
        selection-text = "000000ff";
        selection-match = "000000ff";
        border = "ffffffff";
      };
    };
  };
}
