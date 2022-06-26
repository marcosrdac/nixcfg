final: prev:

with prev;
networkmanager-vpnc.overrideAttrs (old: let
    pname = "NetworkManager-vpnc";
    version = "1.2.6";
    withGnome = false;
  in {
    name = "${pname}${if withGnome then "-gnome" else ""}-${version}";

    src = fetchurl {
      url = "mirror://gnome/sources/NetworkManager-vpnc/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
      sha256 = "sha256-3k/QWcTAg2WkCzK29vrZZ09VZyS0u+sfnURzrBmnRcs=";
    };

    buildInputs = [ vpnc networkmanager glib ]
      ++ lib.optionals withGnome [ gtk3 libsecret libnma ];

    nativeBuildInputs = [ intltool pkg-config file ];

    configureFlags = [
      "--without-libnm-glib"
      "--with-gnome=${if withGnome then "yes" else "no"}"
      "--enable-absolute-paths"
    ];
  }
)
