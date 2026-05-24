{self, ...}: {
  flake.nixosModules.shell-dev-tools = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.dev-tools
    ];
  };
}
