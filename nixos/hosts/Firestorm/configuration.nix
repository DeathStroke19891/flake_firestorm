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

  flake.nixosModules.hostFirestorm = {pkgs, ...}: {
    imports = [
      self.nixosModules.base
      self.nixosModules.user-account

      self.nixosModules.profile-desktop
      self.nixosModules.profile-laptop
      self.nixosModules.profile-development

      self.hardwareModules.Firestorm
    ];

    preferences.user.name = "parzival";

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
    programs.obs-studio.enable = true;

    environment.systemPackages = with pkgs; [
      android-tools
      docker-compose

      firefox
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

      mpv
      obs-studio
      spotify

      pass-wayland
      gnupg
      pinentry-qt

      hledger
      hledger-ui
      obsidian
      thunderbird
      libqalculate
      transmission_4-qt

      copyq
      element-desktop
      mgba
      nemo
      nyxt
    ];
  };
}
