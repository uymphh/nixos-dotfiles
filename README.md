# arctan's NixOS configuration

One flake that builds my whole system — OS, dotfiles, packages — reproducibly.

Rebuild:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

This repo **is** the system: edit a `.nix` file, rebuild, and NixOS produces a
new immutable generation. Roll back with `sudo nixos-rebuild switch --rollback`.

## Layout

```
.
├── flake.nix              # inputs (deps) + outputs (the machine + dev shell)
├── flake.lock             # pins the exact revision of every input
│
├── modules/               # shared system config
│   ├── configuration.nix  # main module: imports the rest, bootloader, users, nix, home-manager
│   ├── desktop.nix        # Hyprland + Noctalia + portals + login manager
│   ├── services.nix       # docker, flatpak, tailscale, steam, bluetooth
│   ├── networking.nix     # NetworkManager + hostname
│   ├── packages.nix       # system-wide packages
│   └── hardware/
│       ├── nvidia.nix     # NVIDIA / hybrid PRIME
│       └── battery.nix    # laptop power management
│
├── hosts/nixos/           # machine-specific
│   ├── default.nix        # imports the hardware file + the shared modules
│   └── hardware-configuration.nix  # disks + kernel modules (generated)
│
└── home/                  # per-user config (home-manager)
    ├── arctan.nix         # user entry point: imports the rest
    ├── hyprland.nix       # Hyprland (Lua) config
    ├── kitty.nix          # terminal
    ├── starship.nix       # shell prompt
    ├── qutebrowser.nix    # browser
    ├── neovim.nix         # Neovim (nvf)
    ├── fonts.nix          # fonts
    └── yt-x.nix           # yt-x
```

Machine-specific values (hostname, GPU, NIC/AC names) are written directly in
the relevant module. There is no abstraction layer.

## Everyday commands

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos   # rebuild + activate (alias: update)
sudo nixos-rebuild boot --flake /etc/nixos#nixos     # apply on next boot
sudo nixos-rebuild switch --rollback                 # undo
cd /etc/nixos && nix flake update && sudo nixos-rebuild switch --flake .#nixos  # update inputs
nix develop                                          # dev shell (gcc/clang/rust)
```

## Adding another machine

1. `cp -r hosts/nixos hosts/<name>` and regenerate its `hardware-configuration.nix`.
2. Point its `default.nix` at the shared modules and adjust the machine-specific
   values in `modules/networking.nix`, `modules/hardware/*`.
3. Add to `flake.nix`:
   ```nix
   nixosConfigurations.<name> = nixpkgs.lib.nixosSystem { ... modules = [ ... ./hosts/<name> ]; };
   ```

## Notes

- `system.stateVersion` (modules/configuration.nix) and `home.stateVersion`
  (home/arctan.nix) pin backwards-compatibility defaults. Set once; never change.
