{
  pkgs,
  lib,
  ...
}: let
  # The prompt body. Indexed ANSI colour names (blue, purple, ...) let the
  # terminal recolour the prompt live. Noctalia's starship template is
  # intentionally not used: it redefines those names as fixed hex.
  starshipBody = pkgs.writeText "starship-body.toml" ''
    # managed-by:nixos-starship-body
    "$schema" = 'https://starship.rs/config-schema.json'

    format = "$directory$git_branch$git_status$container$cpp$c$rust$golang$nodejs$python$java$fill$time$line_break$character"
    add_newline = false
    command_timeout = 1000

    [fill]
    symbol = " "

    [directory]
    style = "bold blue"
    truncation_length = 3
    truncate_to_repo = true
    format = "[ $path ]($style) "

    [git_branch]
    style = "bold purple"
    format = "on [$symbol$branch]($style) "

    [git_status]
    style = "bold red"

    [container]
    style = "bold yellow"

    [cpp]
    style = "bold cyan"

    [c]
    style = "bold blue"

    [rust]
    style = "bold yellow"

    [golang]
    style = "bold cyan"

    [nodejs]
    style = "bold green"

    [python]
    style = "bold yellow"

    [java]
    style = "bold red"

    [time]
    disabled = false
    style = "bold bright-black"
    format = "[ $time ]($style)"
    time_format = "%R"

    [character]
    success_symbol = "[❯](bold green)"
    error_symbol = "[❯](bold red)"
    vimcmd_symbol = "[❮](bold yellow)"
  '';
in {
  home.packages = [ pkgs.starship ];

  programs.bash.initExtra = ''
    eval "$(starship init bash)"
  '';

  # Starship reads one config file, kept writable (not a store symlink) so
  # Noctalia's template hooks can't write through it into the read-only store.
  home.activation.seedStarship = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    conf="$HOME/.config/starship.toml"
    ${pkgs.coreutils}/bin/mkdir -p "$(${pkgs.coreutils}/bin/dirname "$conf")"
    ${pkgs.coreutils}/bin/cat ${starshipBody} > "$conf"
  '';
}
