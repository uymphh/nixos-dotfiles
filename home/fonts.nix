{pkgs, ...}: {
  home.packages = with pkgs; [
    (nerd-fonts.jetbrains-mono)
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = ["JetBrainsMono Nerd Font"];
  };
  xdg.configFile."fontconfig/fonts.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <match target="pattern">
        <test name="family"><string>JetBrains Mono</string></test>
        <edit name="family" mode="assign" binding="strong">
          <string>JetBrainsMono Nerd Font</string>
        </edit>
      </match>
    </fontconfig>
  '';
}
