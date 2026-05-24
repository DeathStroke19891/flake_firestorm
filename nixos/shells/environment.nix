{self, ...}: {
  flake.nixosModules.shell-environment = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.environment
      self.packages.${pkgs.stdenv.hostPlatform.system}.git
    ];

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
