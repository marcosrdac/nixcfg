{ inputs }:

final: prev: {
  nix = final.unstable.nix;
  neovim = import ./neovim final prev;
  polybar = final.unstable.polybar;  # colors = ~/.config/polybar/colors

  networkmanager-vpnc = import ./networkmanager/plugins/vtnc final prev;
  networkmanager-pptp = import ./networkmanager/plugins/pptp final prev;
}
