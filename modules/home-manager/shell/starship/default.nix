{ config, pkgs, ... }:

{
  programs.starship = {
    package = pkgs.unstable.starship;
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "(($username)($hostname):)$directory$character";
      right_format = "$git_state$git_metrics$git_status$git_branch$status";
      character = {  # [\\$]
        format = "$symbol ";
        success_symbol = "[\\$](bold green)";
        error_symbol = "[\\$](bold red)";
        vicmd_symbol = "[\\]](bold purple)";
      }; 
      continuation_prompt = "[ >](bold green) ";
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
        symbol = "<";  # 
        format = "[$symbol$branch](bold purple)";
        truncation_length = 6;
        truncation_symbol = "";
      };
      git_state = { };
      git_status = {
        
        format = ''
          [$up_to_date$conflicted$untracked$modified$renamed$staged$deleted$stashed](bold yellow)[$ahead_behind](bold purple)
        '';  # [!?n+-*](bold yellow)[A](bold purple)
        up_to_date = "";
        conflicted = "=";
        untracked = "?";
        modified = "";  # already using git_metrics
        renamed = "~";
        staged = "+";
        deleted = "-";
        stashed = "*";
        ahead = "A";
        behind = "B";
        diverged = "D";
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
}
