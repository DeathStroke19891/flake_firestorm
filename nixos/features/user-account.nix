{self, ...}: {
  flake.nixosModules.user-account = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      self.nixosModules.extra_hjem
    ];

    users.users.${config.preferences.user.name} = {
      isNormalUser = true;
      description = "${config.preferences.user.name}'s account";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "audio"
        "input"
        "libvirtd"
        "kvm"
        "adbusers"
      ];
      shell = self.packages.${pkgs.stdenv.hostPlatform.system}.environment;
    };

    environment.pathsToLink = ["/share/zsh"];
    programs.zsh.enable = true;

    services.gnome.gnome-keyring.enable = true;
    services.atd.enable = true;
    services.openssh.enable = true;

    environment.systemPackages = with pkgs; [
      vim
      wget
      ntfs3g
      ntfsprogs
      xdg-utils
      psmisc
      dbus
      wireplumber
      cachix
      gcc
      binutils
    ];
  };
}
