{
  flake.nixosModules.pipewire = {
    config,
    pkgs,
    ...
  }: {
    users.users.${config.preferences.user.name}.extraGroups = [
      "audio"
      "jackaudio"
    ];

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
