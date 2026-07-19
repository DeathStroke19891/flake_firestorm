{self, ...}: {
  flake.nixosModules.app-alacritty = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.alacritty
    ];
  };
}
