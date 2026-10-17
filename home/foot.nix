{...}: {
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=11";
        dpi-aware = "yes";
        pad = "12x12";
        selection-target = "clipboard";
      };

      cursor = {
        style = "beam";
        blink = "no";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      scrollback = {
        lines = 10000;
        multiplier = "3.0";
      };

      colors-dark = {
        foreground = "e6e6e6";
        background = "000000";
        regular0 = "1a1a1a";
        regular1 = "808080";
        regular2 = "909090";
        regular3 = "a0a0a0";
        regular4 = "b0b0b0";
        regular5 = "c0c0c0";
        regular6 = "d0d0d0";
        regular7 = "e6e6e6";
        bright0 = "555555";
        bright1 = "999999";
        bright2 = "aaaaaa";
        bright3 = "bbbbbb";
        bright4 = "cccccc";
        bright5 = "dddddd";
        bright6 = "eeeeee";
        bright7 = "ffffff";
        selection-foreground = "000000";
        selection-background = "ffffff";
      };

      key-bindings = {
        font-increase = "Control+plus";
        font-decrease = "Control+minus";
        font-reset = "Control+0";
      };
    };
  };
}
