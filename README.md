# arctan's NixOS configuration

One flake that builds my whole system — OS, dotfiles, packages — reproducibly.

Rebuild:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

This repo **is** the system: edit a `.nix` file, rebuild, and NixOS produces a
new immutable generation. Roll back with `sudo nixos-rebuild switch --rollback`.

## Philosophy

Terminal-first and intentionally lean. The desktop is **Sway** (Wayland) with a
handful of tiny helpers instead of a full compositor shell, so idle CPU and RAM
stay low. There is no Noctalia, no GTK panel, no Electron apps and no bundled
browser engine beyond what WebKitGTK needs.

Everyday surface:

| Role        | Choice                                             |
|-------------|----------------------------------------------------|
| Compositor  | Sway (Wayland)                                      |
| Terminal    | foot                                                |
| Shell       | bash + starship                                     |
| Bar         | swaybar + i3status-rust (CPU/mem/battery/net/clock) |
| Launcher    | fuzzel                                              |
| Notifications | mako                                              |
| Browser     | Brave Origin (Super+Shift+w)                        |
| Files       | yazi (TUI)                                          |
| Editor      | Neovim (nvf) + VSCodium                             |
| Media       | mpv / yt-dlp / ani-cli / yt-x                       |
| Login       | ly (TUI)                                            |

## Layout

```
.
├── flake.nix              # inputs (deps) + outputs (the machine + dev shell)
├── flake.lock             # pins the exact revision of every input
│
├── modules/               # shared system config
│   ├── configuration.nix  # main module: imports the rest, bootloader, users, nix, home-manager
│   ├── desktop.nix        # Sway + wlr portals + ly login manager
│   ├── services.nix       # bluetooth (only)
│   ├── networking.nix     # NetworkManager + hostname
│   ├── packages.nix       # system-wide packages (CLI-first)
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
    ├── sway.nix           # Sway keybindings, bar, colors
    ├── foot.nix           # terminal
    ├── fuzzel.nix         # launcher
    ├── starship.nix       # shell prompt
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
