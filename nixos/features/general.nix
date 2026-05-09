# Common system-wide settings: locale, timezone, shell, keyboard, keyring.
{...}: {
  flake.nixosModules.general = {pkgs, ...}: {
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

    # Make zsh completions available system-wide
    environment.pathsToLink = ["/share/zsh"];
    programs.zsh.enable = true;

    services.xserver.xkb.layout = "us";
    hardware.uinput.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.atd.enable = true;
    services.openssh.enable = true;

    fonts.packages = with pkgs; [liberation_ttf];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = with pkgs; [
      vim
      wget
      libnotify
      ntfs3g
      ntfsprogs
      xdg-utils
      psmisc
      dbus
      wireplumber
      cachix
    ];
  };
}
