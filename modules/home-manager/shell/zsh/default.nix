{ config, pkgs, ... }:

{
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
