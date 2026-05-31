{
  flake.nixosModules.app-utilities = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      nemo
      libqalculate
      pass-wayland
      gnupg
      pinentry-qt
      transmission_4-qt
    ];
  };
}
