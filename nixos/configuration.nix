# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.nix-alien.overlays.default
  ];

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Firestorm"; # Define your hostname.
  networking.nameservers = ["9.9.9.9"];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "dvp";
  };

  console.keyMap = "dvorak-programmer";
  hardware.uinput.enable = true;

  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.parzival = {
    isNormalUser = true;
    description = "Sridhar D Kedlaya";
    extraGroups = ["networkmanager" "wheel" "video" "audio" "input" "uinput" "power" "docker"];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Testing new rebuild script
  environment.systemPackages = with pkgs; [
    vim
    home-manager
    (import ./derivations/rebuild.nix {inherit pkgs;})
    (import ./derivations/home-rebuild.nix {inherit pkgs;})
    wget
    libnotify
    ntfs3g
    ntfsprogs
    xdg-utils
    psmisc
    dbus
    wireplumber
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5ct
    libsForQt5.qt5.qtgraphicaleffects
    qt6Packages.qt6ct
    nix-alien
  ];

  fonts.packages = with pkgs; [
    liberation_ttf
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    HYPRCURSOR_THEME = "hyprcursor_Dracula";
    HYPRCURSOR_SIZE = "24";
  };

  environment.pathsToLink = ["/share/zsh"];

  programs.nix-ld = {
    enable = true;
  };

  programs.auto-cpufreq.enable = true;

  programs.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      turbo = "auto";
    };

    battery = {
      governor = "powersave";
      turbo = "never";
    };
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  programs.light.enable = true;

  programs.zsh.enable = true;

  programs.steam = {
    enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.displayManager = {
    sddm.enable = true;
    sddm.theme = "${import ./derivations/sddm-theme.nix {inherit pkgs;}}";
    sddm.wayland.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = ["parzival"];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };

  services.atd = {
    enable = true;
  };

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/monokai.yaml";
  stylix.image = /home/parzival/pictures/wallpapers/hacking.jpg;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
