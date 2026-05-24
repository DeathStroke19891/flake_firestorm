{self, ...}: {
  flake.nixosModules.shell-environment = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.environment
      self.packages.${pkgs.stdenv.hostPlatform.system}.git
    ];
  };
}
