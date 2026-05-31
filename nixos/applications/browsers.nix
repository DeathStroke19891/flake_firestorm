{inputs, ...}: {
  flake.nixosModules.app-browsers = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.firefox
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.nyxt
    ];
  };
}
