{
  flake.nixosModules.app-media = {pkgs, ...}: {
    programs.obs-studio.enable = true;

    environment.systemPackages = with pkgs; [
      mpv
      obs-studio
      spotify
    ];
  };
}
