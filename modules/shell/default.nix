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
        symbol = "";
        format = "[$symbol$branch](bold purple)";
        truncation_length = 6;
        truncation_symbol = "";
      };
      git_state = { };
      git_status = {
        style = "bold yellow";
        format = ''
          [$conflicted$untracked$staged$modified$renamed$deleted$stashed$ahead_behind]($style)
          '';
        modified = "";  # already using git_metrics
        up_to_date = "";
        ahead = "A";
        behind = "B";
        diverged = "D";
        conflicted = "!";
        untracked = "?";
        stashed = "*";
        deleted = "d";
        renamed = "m";
        staged = "s";
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
    dotDir = ".config/shell";
    shellAliases = { };

    history = {
      save = 1000000000;
      size = 1000000000;
      path = "${config.xdg.dataHome}/shell/history";
    };

    initExtra = ''
      # basic auto tab completion
      autoload -U compinit && compinit
      zstyle ':completion:*' menu select
      zmodload zsh/complist
      _comp_options+=(globdots)  # include hidden files

      # vi mode transitions faster (cs)
      export KEYTIMEOUT=1 

      # vi mode
      bindkey -v
      bindkey '^R' history-incremental-pattern-search-backward
      
      # use vi keys in tab complete menu
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -v '^?' backward-delete-char

      # options
      DIRSTACKSIZE=20
      setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME
      setopt PUSHD_IGNORE_DUPS # Remove duplicate entries
      setopt PUSHD_MINUS # This reverts the +/- operators.

      # history From https://unix.stackexchange.com/a/273863
      setopt BANG_HIST                 # Treat the '!' character specially during expansion.
      unsetopt EXTENDED_HISTORY        # Write the history file in the ":start:elapsed;command" format.
      setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
      setopt SHARE_HISTORY             # Share history between all sessions.
      HISTORY_IGNORE="rm \*|fortune"
      setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
      setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
      setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
      setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
      setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
      setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
      setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
      unsetopt HIST_VERIFY             # Don't execute immediately upon history expansion.
      unsetopt HIST_BEEP               # Beep when accessing nonexistent history.

      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    '';
  };
}
