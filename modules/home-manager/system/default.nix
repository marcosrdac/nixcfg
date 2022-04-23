{ config, pkgs, ... }:

with pkgs.lib;
{
  options.system = mkOption {
    type = with types; uniq str;
    description = "System architecture";
    default = "x86_64-linux";
    example = "x86_64-linux";
  };
}
