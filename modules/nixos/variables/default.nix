{ pkgs, config, ... }:

with pkgs.lib;
let
  cfg = config.variables;
in
{
  options.variables = {
    enable = mkOption {
      description = "Enable session variables configuration";
      type = with types; bool;
      default = true;
    };

    useDefault = mkOption {
      description = "Whether to use default environment variables or not";
      type = with types; bool;
      default = true;
    };

    definitions = mkOption {
      description = "Extra variables";
      type = with types; attrsOf str;
      default = { };
      example = literalExpression ''{ EDITOR = "nano"; }'';
    };
  };

  config = let
    defaultVariables = {
      EDITOR = "nvim";
    };
  in {
    environment.variables = mkIf cfg.enable
      ((mkIf cfg.useDefault defaultVariables) // cfg.definitions);
  };
}
