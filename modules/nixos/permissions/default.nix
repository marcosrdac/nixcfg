{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.permissions;
in
{
  options.permissions = {

    enable = mkEnableOption "Enable default user configurations";

    users = mkOption {
      type = with types; attrs;
      description = "Set of users for the machine";
      default = { };
      example = literalExpression ''{
        "marcos" = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          openssh.authorizedKeys = [ "your-ssh-pubkey-here" ];
        };
        "family" = {
          isNormalUser = true;
        };
      }'';
    };

    defaultGroups = mkOption {
      type = with types; listOf string;
      description = "Groups every user belongs to";
      default = [ ];
      example = literalExpression ''[ "lp" ]'';
    };
    openssh.defaultAuthorizedKeys = mkOption {
      type = with types; listOf string;
      description = "SSH keys every user can login from";
      default = [ ];
      example = literalExpression ''[ "your-ssh-pubkey-here" ]'';
    };

    defaultUserShell = mkOption {
      type = with types; package;
      description = "Default user shell";
      default = pkgs.zsh;
      example = literalExpression ''pkgs.bash'';
    };
  };

  config = let
    allUsers = builtins.attrNames cfg.users;
    mergeDefaults = mapAttrs (username: settings: mkMerge [
      settings
      { extraGroups = cfg.defaultGroups; }
      { openssh.authorizedKeys.keys = cfg.openssh.defaultAuthorizedKeys; }
    ]);
  in mkIf cfg.enable {
    users.users = mergeDefaults cfg.users;
    nix.allowedUsers = allUsers;
    users.defaultUserShell = cfg.defaultUserShell;
    programs.zsh.enable = true;

    # enable system programs completion for users
    # TODO check if it actually occurs
    # TODO pass this to a common zsh/shell module, but only load it on nixos
    environment.pathsToLink = [ "/share/zsh" ];


    # make users of nixcfg group to be able to modify configurations
    users.groups.nixcfg.gid = null;
    system.activationScripts = {
      nixos-config-permissions = ''
        echo "setting up permissions for /etc/nixos..."
        chgrp -R nixcfg /etc/nixos
        find /etc/nixos -type d -exec chmod u=rwx,g=rwx,o=rx {} \;
        find /etc/nixos -type f -exec chmod u+rw,g+rw,o+r {} \;
      '';
    };
  };
}
