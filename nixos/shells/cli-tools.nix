{self, ...}: {
  flake.nixosModules.shell-cli-tools = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.cli-tools
    ];
  };
}
