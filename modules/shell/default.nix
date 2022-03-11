{ config, pkgs, ... }:

{
  programs.starship = {
    package = pkgs.unstable.starship;
    enable = true;
    enableZshIntegration = true;
    settings = {
      character = {  # [\\$]
        format = "$symbol ";
        success_symbol = "[\\$](bold green)";
        error_symbol = "[\\$](bold red)";
        vicmd_symbol = "[\\]](bold purple)";
      };
      add_newline = false;
      format = ''
        (($username)($hostname):)$directory$character
      '';
      right_format = ''
        $git_metrics$git_status$git_branch$status
      '';
        #[┌─](bold green)$directory(
        #[│](bold green)($git_branch)($git_status)($git_metrics))
        #[└](bold green)($username)($hostname )$character
      continuation_prompt = "+ ";
      status = {
        disabled = false;
        format = "( [\\[](bold yellow)[$status]($style)[\\]](bold yellow))";
      };
      directory = {
        style = "bold cyan";
        read_only = "[w]";
        read_only_style	= "red";
        format = "[$path]($style)[$read_only]($read_only_style)";
        truncation_length = 4;
        truncation_symbol = "+/";
      };
      git_branch = {
        symbol = "";
        format = "[$symbol$branch](bold purple)";
        truncation_length = 6;
        truncation_symbol = "";
      };
      git_state = { };
      git_status = {
        style = "bold yellow";
        format = "([$all_status]($style))";
      };
      git_metrics = {
        disabled = false;
        added_style = "bold green";
        deleted_style = "bold red";
        format = "([+$added]($added_style))([-$deleted]($deleted_style))";
      };
      hostname = {
        style = "bold green";
        format = "[@](dimmed green)[$hostname]($style)";
      };
      username = {
        style_root = "bold red";
        style_user = "bold yellow";
        format = "[$user]($style)";
        show_always = false;
      };

      package.disabled = true;
    };
  };
  
  programs.zsh = {
    enable = true;
    #dotDir = ".config/zsh";
    enableAutosuggestions = true;
    shellAliases = { };

    history = {
      ignoreDups = true;
      save = 1000000;
      size = 1000000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initExtra = ''
      # vi mode transitions faster (cs)
      export KEYTIMEOUT=1
      bindkey -v
    '';
  };
}
