{...}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      add_newline = false;
      command_timeout = 1000;

      format = "$directory$git_branch$git_status$container$cpp$c$rust$golang$nodejs$python$java$fill$time$line_break$character";

      fill.symbol = " ";

      directory = {
        style = "bold blue";
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[ $path ]($style) ";
      };

      git_branch = {
        style = "bold purple";
        format = "on [$symbol$branch]($style) ";
      };

      git_status.style = "bold red";
      container.style = "bold yellow";
      cpp.style = "bold cyan";
      c.style = "bold blue";
      rust.style = "bold yellow";
      golang.style = "bold cyan";
      nodejs.style = "bold green";
      python.style = "bold yellow";
      java.style = "bold red";

      time = {
        disabled = false;
        style = "bold bright-black";
        format = "[ $time ]($style)";
        time_format = "%R";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold yellow)";
      };
    };
  };
}
