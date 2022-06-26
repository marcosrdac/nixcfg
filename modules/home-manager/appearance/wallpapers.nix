pkgs: with pkgs;

{ 
  # fetch-file URL then paste below
  dark-blue-earth-from-moon = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/4x/wallhaven-4x6e2v.jpg";
    sha256 = "0i8jnx2c0hqq5aj7wx9f8i52p4hxg2fdxahaqr7vrksaq3xz259w";
  };
  yellow-astronaut-landing = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/j5/wallhaven-j5ledp.jpg";
    sha256 = "0wl4scnfnc5y35yb9vzg024sv3rr7lmsnxq7r6b3drafi8pl204k";
  };
  blue-lake-mountains = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/4v/wallhaven-4vj3zp.jpg";
    sha256 = "0iyxj53jab75rcw5j0kyiymasvxq5hg86y7gjnj2rqxn7l6mf2ga";
  };
  green-machu-pichu = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/95/wallhaven-95rr3k.jpg";
    sha256 = "1wg0lbr69mqxn897rlcqvrlnhafn8vsrf7sd5fk4iwzzndils4sw";
  };
  brown-ravine = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/mp/wallhaven-mp7g28.jpg";
    sha256 = "03a7fkrg78hlfxsbxv247km9klaq89dy7vbnl547jk4h1n035ynh";
  };
}
