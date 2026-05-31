{
  flake.nixosModules.app-productivity = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      obsidian
      copyq
      hledger
      hledger-ui
    ];
  };
}
