# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'

pkgs: {
  astronaut-sddm-theme = pkgs.callPackage ./astronaut-sddm-theme { inherit pkgs; };
  battery-health = pkgs.callPackage ./battery-health { inherit pkgs; };
  alarm = pkgs.callPackage ./alarm { inherit pkgs; };
  pass-show = pkgs.callPackage ./pass-show { inherit pkgs; };
  screenshot = pkgs.callPackage ./screenshot { inherit pkgs; };
  rebuild = pkgs.callPackage ./rebuild { inherit pkgs; };
}
