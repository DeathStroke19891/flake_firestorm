{self, ...}: {
  flake.nixosModules.profile-desktop = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      self.nixosModules.gtk
      self.nixosModules.pipewire
      self.nixosModules.bluetooth
      self.nixosModules.sddm

      self.nixosModules.app-alacritty
      self.nixosModules.app-niri
      self.nixosModules.app-noctalia
      self.nixosModules.app-sioyek
    ];

    users.users.${config.preferences.user.name}.extraGroups = [
      "video"
    ];

    services.xserver.xkb.layout = "us";
    services.gnome.gnome-keyring.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      awww
      fastfetch
      viewnior
      xdg-utils
      wireplumber
    ];

    fonts.packages = with pkgs; [
      liberation_ttf
      noto-fonts-color-emoji
      lohit-fonts.devanagari
      lohit-fonts.kannada
      lohit-fonts.tamil
      lohit-fonts.malayalam
      lohit-fonts.telugu
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.monaspace
      nerd-fonts.mononoki
    ];

    fonts.fontconfig.defaultFonts = {
      monospace = ["MonaspiceNe Nerd Font"];
    };

    security.polkit.enable = true;
  };
}
