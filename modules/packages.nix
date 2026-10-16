# System-wide packages. yt-x comes from its own flake input (see flake.nix).
{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    git
    wget
    curl

    librewolf
    qutebrowser

    playerctl
    pavucontrol
    networkmanagerapplet
    kitty

    thunar
    tumbler
    thunar-volman
    thunar-archive-plugin
    gvfs

    gdu
    prismlauncher
    thunderbird
    postman
    discord
    libreoffice
    btop
    powertop
    unzip
    opencode
    ripgrep
    fzf
    inputs.yt-x.packages.${pkgs.stdenv.hostPlatform.system}.default
    mpv
    jq
    ani-cli
    yt-dlp
    ueberzugpp
    bibata-cursors
    tree
    chafa
    vscode
    nodejs

    gcc
    clang
    clang-tools
    gdb
    cmake
    ninja
    gnumake
    pkg-config

    rustc
    cargo
    clippy
    rustfmt
    rust-analyzer

  ];
}
