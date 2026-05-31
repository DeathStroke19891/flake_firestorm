{
  flake.nixosModules.app-communication = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      element-desktop
      thunderbird
    ];
  };
}
