{
  pkgs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./hyprland.nix
    ./kitty.nix
    ./qutebrowser.nix
    ./starship.nix
    ./neovim.nix
    ./yt-x.nix
  ];

  home.username = "arctan";
  home.homeDirectory = "/home/arctan";

  home.packages = with pkgs; [
    gh
    imagemagick
  ];

  programs.yazi.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    colorScheme = "dark";
    font = {
      name = "JetBrains Mono";
      size = 11;
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -lah";
      update = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      nvidia-on = "nvidia-offload";
    };
    initExtra = ''
      # Load the Noctalia-generated fzf theme (if rendered yet).
      noctalia_fzf="''${XDG_CONFIG_HOME:-$HOME/.config}/fzf/themes/noctalia.sh"
      [ -f "$noctalia_fzf" ] && . "$noctalia_fzf"
    '';
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "uymphh";
        email = "uymph@proton.me";
      };
      credential.helper = "!gh auth git-credential";
    };
  };

  home.stateVersion = "26.05";
}

