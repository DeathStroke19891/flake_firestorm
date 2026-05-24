{self, ...}: {
  flake.nixosModules.app-sioyek = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.sioyek
    ];
  };
}
