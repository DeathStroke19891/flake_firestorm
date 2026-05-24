{self, ...}: {
  flake.nixosModules.app-niri = {pkgs, ...}: let
    selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    programs.niri.enable = true;
    programs.niri.package = selfpkgs.niri;

    hardware.graphics.enable = true;
    hardware.uinput.enable = true;

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gnome
    ];

    environment.systemPackages = with pkgs; [
      wl-clipboard
      brightnessctl
      pulsemixer
    ];
  };
}
