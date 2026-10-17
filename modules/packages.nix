# System-wide packages. Terminal-first and deliberately lean: everything here
# is either a CLI program or a small Wayland helper. Browsers, terminals, the
# bar and notifications are managed per-user in home-manager.
{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # core CLI
    git
    wget
    curl
    ripgrep
    fzf
    fd
    jq
    tree
    unzip
    p7zip
    xdg-utils

    # system / process inspection
    btop
    powertop
    gdu

    # terminal niceties
    chafa

    # Wayland session helpers (invoked from sway keybindings)
    fuzzel
    grim
    slurp
    wl-clipboard
    swappy
    swaybg
    swaylock
    swayidle
    brightnessctl
    pamixer
    playerctl

    # network / bluetooth TUIs
    impala
    bluetui

    # media (CLI)
    mpv
    ffmpeg
    ani-cli
    yt-dlp

    # browsers
    dillo-plus
    brave-origin

    # light graphical apps
    imv
    mupdf

    # theming
    bibata-cursors

    # dev toolchain
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
    nodejs

    opencode
  ];
}
