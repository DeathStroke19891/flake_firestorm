{...}: {
  flake.nixosModules.audio = {pkgs, ...}: {
    security.rtkit.enable = true;
    services.pipewire = {
      package = pkgs.pipewire;
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
