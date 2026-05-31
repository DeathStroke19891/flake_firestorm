{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.Firestorm = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit (self) theme themeNoHash;
      inherit self;
    };
    modules = [self.nixosModules.hostFirestorm];
  };

  flake.nixosModules.hostFirestorm = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      self.nixosModules.base

      self.nixosModules.profile-desktop
      self.nixosModules.profile-laptop
      self.nixosModules.profile-development

      self.nixosModules.app-browsers
      self.nixosModules.app-media
      self.nixosModules.app-productivity
      self.nixosModules.app-communication
      self.nixosModules.app-utilities
      self.nixosModules.app-gaming
      self.nixosModules.app-creative

      self.hardwareModules.Firestorm
    ];

    preferences.user.name = "parzival";

    users.users.${config.preferences.user.name} = {
      description = "Sridhar D Kedlaya";
      shell = self.packages.${pkgs.stdenv.hostPlatform.system}.environment;
      extraGroups = [
        "docker"
        "libvirtd"
        "kvm"
        "adbusers"
      ];
    };

    system.stateVersion = "23.11";

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
      };
      supportedFilesystems.ntfs = true;
      kernelParams = ["quiet" "splash"];
      plymouth.enable = true;
    };

    networking = {
      hostName = "Firestorm";
      networkmanager.enable = true;
      enableIPv6 = true;
      firewall.enable = true;
    };

    services.udisks2.enable = true;

    virtualisation.libvirtd.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    programs.appimage.enable = true;
    programs.appimage.binfmt = true;

    environment.systemPackages = with pkgs; [
      ntfs3g
      ntfsprogs
    ];
  };
}
