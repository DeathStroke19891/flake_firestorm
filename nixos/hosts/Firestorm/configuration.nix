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

      self.nixosModules.general
      self.nixosModules.desktop

      self.nixosModules.input
      self.nixosModules.power

      self.hardwareModules.Firestorm
    ];

    preferences.user.name = "parzival";

    system.stateVersion = "23.11";

    services = {
      udisks2.enable = true;
    };

    boot = {

      loader = {
        systemd-boot.enable = true;

        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
      };

      supportedFilesystems.ntfs = true;

      kernelParams = [
        "quiet"
        "splash"
      ];

      plymouth.enable = true;
    };

    networking = {
      hostName = "Firestorm";
      networkmanager.enable = true;
      enableIPv6 = true;
      firewall.enable = true;
    };

    virtualisation.libvirtd.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };

    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
    xdg.portal.enable = true;

    environment.systemPackages = with pkgs; [
      android-tools
      docker-compose 
    ];

    hardware.graphics.enable = true;
    programs.niri.enable = true;


    programs.appimage.enable = true;
    programs.appimage.binfmt = true;

    programs.obs-studio.enable = true;
  };
}
