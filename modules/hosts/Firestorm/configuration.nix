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

      self.nixosModules.docker
      self.nixosModules.input
      self.nixosModules.power

      self.nixosModules.hardwareFirestorm
    ];

    preferences.user.name = "parzival";

    networking.hostName = "Firestorm";
    networking.networkmanager.enable = true;
    networking.enableIPv6 = true;

    boot.loader.systemd-boot.enable = false;
    boot.loader.grub.enable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.useOSProber = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
    boot.kernelPackages = pkgs.linuxPackages_zen;

    environment.systemPackages = [pkgs.docker-compose];

    system.stateVersion = "23.11";
  };
}
