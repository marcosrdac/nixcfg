final: prev:

with prev;

# TODO
# REQUIRED
#networking.firewall.autoLoadConntrackHelpers = true;

#https://github.com/NixOS/nixpkgs/blob/release-17.09/pkgs/tools/networking/network-manager/pptp.nix
#https://github.com/NixOS/nixpkgs/blob/nixos-21.05/pkgs/tools/networking/ppp/default.nix

(final.nixos-17.networkmanager_pptp.override {
  #withGnome = false;
  #gnome3 = null;
}).overrideAttrs (old: {
  passthru = {
    networkManagerPlugin = "VPN/nm-pptp-service.name";
  };
})



#builtins.trace (builtins.attrNames final.nixos-17)
#final.nixos-17.tools.networking.network-manager.pptp

#final.nixos-17.networkmanager-vpnc.overrideAttrs (old: {

#})






#prev.networkmanager-vpnc.overrideAttrs (old: rec {
  #name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  #pname   = "NetworkManager-pptp";
  #major   = "1.2";
  #withGnome = false;
  #version = "${major}.4";  # 4  # 8

  #src = fetchurl {
    #url    = "mirror://gnome/sources/${pname}/${major}/${pname}-${version}.tar.xz";
    #sha256 = "sha256-vZfOdow0zObVtdQ2gRSagwC+x1Q5ej9GoNjQrqcDDF4=";  # 4
    ##sha256 = "sha256-+ONeSpp2MSl1wxfNMV5em9I7uitcMcMlnIwVBYPcGVM=";  # 8
  #};

  #patches = [ ];

  #buildInputs = [ networkmanager pptp ppp libsecret libnma libnma-gtk4 ]
    #++ lib.optionals withGnome [ gtk3 gnome.libgnome-keyring
                                        #pkgs.networkmanagerapplet ];

  #nativeBuildInputs = [ file intltool pkgconfig libnma libnma-gtk4 ];

  #postPatch = ''
    #sed -i -e 's%"\(/usr/sbin\|/usr/pkg/sbin\|/usr/local/sbin\)/[^"]*",%%g' ./src/nm-pptp-service.c
    #substituteInPlace ./src/nm-pptp-service.c \
      #--replace /sbin/pptp ${pptp}/bin/pptp \
      #--replace /sbin/pppd ${ppp}/bin/pppd
  #'';

  #configureFlags = [
    #(if withGnome then "--with-gnome --with-gtkver=3" else "--without-gnome")
  #];

  #passthru = {
    #networkManagerPlugin = "VPN/nm-pptp-service.name";
  #};
#})
