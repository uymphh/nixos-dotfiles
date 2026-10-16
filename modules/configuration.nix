{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./desktop.nix
    ./services.nix
    ./networking.nix
    ./packages.nix
    ./hardware/battery.nix
    ./hardware/nvidia.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "caps:escape";
  };

  users.users."arctan" = {
    isNormalUser = true;
    description = "arctan";
    extraGroups = ["networkmanager" "wheel" "video" "render"];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.arctan = {inputs, ...}: {
      imports = [
        inputs.nvf.homeManagerModules.default
        ../home/arctan.nix
      ];
    };
  };

  system.stateVersion = "26.05";
}
