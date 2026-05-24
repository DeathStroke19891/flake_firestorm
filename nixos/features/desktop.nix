{self, ...}: {
  flake.nixosModules.desktop = {pkgs, ...}: let
    selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    imports = [
      self.nixosModules.gtk
      self.nixosModules.pipewire
      self.nixosModules.bluetooth
      self.nixosModules.sddm
    ];

    programs.niri.enable = true;
    programs.niri.package = selfpkgs.niri;

    preferences.autostart = [selfpkgs.noctalia-shell];

    environment.systemPackages = with pkgs; [
      awww
      wl-clipboard
      brightnessctl
      pulsemixer
      fastfetch
      viewnior
    ];

    fonts.packages = with pkgs; [
      liberation_ttf
      noto-fonts-color-emoji
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.monaspace
      nerd-fonts.mononoki
    ];

    fonts.fontconfig.defaultFonts = {
      monospace = ["MonaspiceNe Nerd Font"];
    };

    time.timeZone = "Asia/Kolkata";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };

    security.polkit.enable = true;
    hardware.uinput.enable = true;
  };
}
