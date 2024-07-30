{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages

      inputs.nix-alien.overlays.default
      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # FIXME: Add the rest of your current configuration

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Enable networking
  networking.nameservers = ["9.9.9.9"];
  networking.networkmanager.enable = true;
  networking.enableIPv6 = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  environment.systemPackages = with pkgs; [
    vim
    rebuild
    home-rebuild
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
    docker-compose
  ];

  fonts.packages = with pkgs; [
    liberation_ttf
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    HYPRCURSOR_THEME = "hyprcursor_Dracula";
    HYPRCURSOR_SIZE = "24";
  };

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

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  environment.pathsToLink = ["/share/zsh"];
  programs.zsh.enable = true;

  programs.steam = {
    enable = true;
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  virtualisation.podman.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          })
          .fd
        ];
      };
    };
  };

  programs.virt-manager.enable = true;

  programs.light.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:

  services.xserver.xkb = {
    layout = "us";
    variant = "dvp";
  };

  console.keyMap = "dvorak-programmer";
  hardware.uinput.enable = true;

  # sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    package = pkgs.pipewire;
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  #services.xserver.enable = true;
  #services.xserver.desktopManager.plasma6.enable = true;

  services.displayManager.sddm = {
    enable = true;
    theme = "${pkgs.astronaut-sddm-theme}";
    wayland.enable = true;
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = ["parzival"];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.atd = {
    enable = true;
  };

  services.kubo = {
    enable = true;
  };

  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/monokai.yaml";
  # stylix.image = /home/parzival/pictures/wallpapers/hacking.jpg;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.hostName = "Firestorm";

  users.users = {
    parzival = {
      isNormalUser = true;
      description = "Sridhar D Kedlaya";
      extraGroups = ["networkmanager" "wheel" "video" "audio" "input" "uinput" "power" "docker" "libvirtd" "jackaudio" config.services.kubo.group];
      packages = with pkgs; [];
      shell = pkgs.zsh;
    };
  };

  services.openssh = {
    enable = true;
  };

  system.stateVersion = "23.11";
}
