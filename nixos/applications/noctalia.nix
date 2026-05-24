{self, ...}: {
  flake.nixosModules.app-noctalia = {pkgs, ...}: let
    selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    preferences.autostart = [selfpkgs.noctalia-shell];

    environment.systemPackages = [
      selfpkgs.noctalia-shell
    ];
  };
}
