{
  flake.nixosModules.app-gaming = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      mgba
    ];
  };
}
