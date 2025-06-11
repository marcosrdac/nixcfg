pkgs: with pkgs;

{
  spleen = {
    name = "Spleen 16x32 Medium";
    package = pkgs.spleen;
    size = 12;
  };
  iosevka = {
    name = "iosevka";
    package = pkgs.iosevka;
    size = 10;
  };
  iosevka-comfy = {
    name = "Iosevka Comfy";
    package = iosevka-comfy.iosevka-comfy;
    size = 10;
  };
}
