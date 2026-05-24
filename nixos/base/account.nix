{self, ...}: {
  flake.nixosModules.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.extra_hjem
    ];

    users.users.${config.preferences.user.name} = {
      isNormalUser = true;
      description = lib.mkDefault "${config.preferences.user.name}'s account";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = lib.mkDefault pkgs.zsh;
    };

    environment.pathsToLink = ["/share/zsh"];
    programs.zsh.enable = true;

    services.openssh.enable = true;
    services.atd.enable = true;

    environment.systemPackages = with pkgs; [
      vim
      wget
      psmisc
      dbus
      cachix
    ];
  };
}
