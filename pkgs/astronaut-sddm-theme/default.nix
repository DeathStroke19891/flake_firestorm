{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchurl {
    url = "https://github.com/totoro-ghost/sddm-astronaut/archive/refs/heads/master.zip";
    sha256 = "0b0m7gn78bwcffx3l7696p1inp61qncaa4yalfiah7r69lyn5iqn";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    ${pkgs.unzip}/bin/unzip $src -d $out/
    mv $out/sddm-astronaut-master/* $out/
    rm -r $out/sddm-astronaut-master
  '';
}
