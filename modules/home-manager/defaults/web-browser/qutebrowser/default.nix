{ config, pkgs, ... }:

let
  font = "Monospace 11";
in
{
  programs.qutebrowser = {
    enable = true;
    aliases = { };
    #loadAutoconfig = false;
    searchEngines = { };
    keyMappings = { };
    keyBindings = { };
    enableDefaultBindings = true;
    #quickmarks = { };
    extraConfig = builtins.concatStringsSep "\n" [
      (pkgs.lib.strings.fileContents ./config.py)
      ''
      c.editor.command = ['${config.home.sessionVariables.TERMINAL}', '-e', os.environ.get('EDITOR'), '{}']

      try:
          import extra.py
      except ImportError:
          pass
      ''
    ];
  };

  xdg.configFile = let 
    reloadQutebrowser = ''
      hash="$(echo -n "$USER" | md5sum | cut -d' ' -f1)"
      socket="''${XDG_RUNTIME_DIR:-/run/user/$UID}/qutebrowser/ipc-$hash"
      if [[ -S $socket ]]; then
        command=${
          pkgs.lib.escapeShellArg (builtins.toJSON {
            args = [ ":config-source" ];
            target_arg = null;
            protocol_version = 1;
          })
        }
        echo "$command" | ${pkgs.socat}/bin/socat -lf /dev/null - UNIX-CONNECT:"$socket"
      fi
      unset hash socket command
    '';
  in {
    "qutebrowser/colors.yml" = {
      text = import ./colors.yml.nix config.colorscheme;
      onChange = reloadQutebrowser;
    };
    "qutebrowser/blank.yml" = {
      text = import ./blank.html.nix config.colorscheme;
      onChange = reloadQutebrowser;
    };
  };

}
