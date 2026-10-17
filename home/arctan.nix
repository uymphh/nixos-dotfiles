{
  pkgs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./sway.nix
    ./foot.nix
    ./fuzzel.nix
    ./dillo.nix
    ./starship.nix
    ./neovim.nix
  ];

  home.username = "arctan";
  home.homeDirectory = "/home/arctan";

  home.packages = with pkgs; [
    gh
    imagemagick
  ];

  programs.yazi = {
    enable = true;

    # Black & white theme (overrides yazi's dark preset with grayscale).
    theme = {
      mgr = {
        cwd = { fg = "#ffffff"; };
        find_keyword = { fg = "#ffffff"; bold = true; underline = true; };
        find_position = { fg = "#888888"; bg = "reset"; bold = true; };
        marker_copied = { fg = "#888888"; bg = "#888888"; };
        marker_cut = { fg = "#888888"; bg = "#888888"; };
        marker_marked = { fg = "#aaaaaa"; bg = "#aaaaaa"; };
        marker_selected = { fg = "#ffffff"; bg = "#ffffff"; };
        count_copied = { fg = "#000000"; bg = "#cccccc"; };
        count_cut = { fg = "#000000"; bg = "#888888"; };
        count_selected = { fg = "#000000"; bg = "#ffffff"; };
        border_style = { fg = "#555555"; };
      };
      tabs = {
        active = { fg = "#000000"; bg = "#ffffff"; bold = true; };
        inactive = { fg = "#888888"; bg = "#222222"; };
      };
      mode = {
        normal_main = { fg = "#000000"; bg = "#ffffff"; bold = true; };
        normal_alt = { fg = "#ffffff"; bg = "#333333"; };
        select_main = { fg = "#000000"; bg = "#ffffff"; bold = true; };
        select_alt = { fg = "#ffffff"; bg = "#333333"; };
        unset_main = { fg = "#000000"; bg = "#ffffff"; bold = true; };
        unset_alt = { fg = "#ffffff"; bg = "#333333"; };
      };
      status = {
        perm_type = { fg = "#ffffff"; };
        perm_read = { fg = "#bbbbbb"; };
        perm_write = { fg = "#888888"; };
        perm_exec = { fg = "#cccccc"; };
        progress_normal = { fg = "#ffffff"; bg = "#000000"; };
        progress_error = { fg = "#000000"; bg = "#ffffff"; };
      };
      which = {
        border = { fg = "#555555"; };
        cand = { fg = "#ffffff"; };
        rest = { fg = "#777777"; };
        desc = { fg = "#aaaaaa"; };
      };
      confirm = {
        border = { fg = "#555555"; };
        title = { fg = "#ffffff"; };
      };
      spot = {
        border = { fg = "#555555"; };
        title = { fg = "#ffffff"; };
        tbl_col = { fg = "#ffffff"; };
        tbl_cell = { fg = "#000000"; bg = "#ffffff"; };
      };
      notify = {
        title_info = { fg = "#cccccc"; };
        title_warn = { fg = "#ffffff"; };
        title_error = { fg = "#ffffff"; };
      };
      pick = {
        border = { fg = "#555555"; };
        active = { fg = "#ffffff"; bold = true; };
        inactive = { fg = "#888888"; };
      };
      input = {
        border = { fg = "#555555"; };
        selected = { fg = "#000000"; bg = "#ffffff"; };
      };
      cmp = {
        border = { fg = "#555555"; };
        active = { fg = "#000000"; bg = "#ffffff"; };
        inactive = { fg = "#888888"; };
      };
      tasks = {
        border = { fg = "#555555"; };
        hovered = { fg = "#ffffff"; bold = true; };
      };
      help = {
        border = { fg = "#555555"; };
        chord = { fg = "#cccccc"; };
        hovered = { fg = "#000000"; bg = "#ffffff"; bold = true; };
      };
      filetype.rules = [
        { mime = "**/image/*"; fg = "#bbbbbb"; }
        { mime = "**/{audio,video}/*"; fg = "#bbbbbb"; }
        { mime = "**/application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}"; fg = "#cccccc"; }
        { mime = "**/application/{pdf,doc,rtf}"; fg = "#dddddd"; }
        { mime = "vfs/{absent,stale}"; fg = "#777777"; }
        { url = "*"; is = "orphan"; bg = "#ffffff"; }
        { url = "*"; is = "exec"; fg = "#ffffff"; }
        { url = "*"; is = "dummy"; bg = "#ffffff"; }
        { url = "*/"; is = "dummy"; bg = "#ffffff"; }
        { url = "*/"; fg = "#dddddd"; }
      ];
    };
  };

  gtk = {
    enable = true;
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
