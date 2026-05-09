{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.Firestorm = inputs.nixpkgs.lib.nixosSystem {
    # Pass self so NixOS modules can reference self.packages.${system}.*
    specialArgs = {
      inherit (self) theme themeNoHash;
      inherit self;
    };
    modules = [self.nixosModules.hostFirestorm];
  };

  flake.nixosModules.hostFirestorm = {
    config,
    pkgs,
    self, # from specialArgs
    ...
  }: let
    user = config.preferences.user.name;
    system = pkgs.stdenv.hostPlatform.system;
  in {
    imports = [
      self.nixosModules.base

      self.nixosModules.nix
      self.nixosModules.general
      self.nixosModules.audio
      self.nixosModules.bluetooth
      self.nixosModules.docker
      self.nixosModules.niri
      self.nixosModules.sddm
      self.nixosModules.input
      self.nixosModules.power
      self.nixosModules.gtk

      self.nixosModules.hardwareFirestorm

      self.nixosModules.extra_hjem
      # Note: alacritty / mako / sioyek / git / zsh / tmux NixOS modules removed.
      # All programs are now perSystem.packages.* wrapped derivations (see below).
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

    users.users.${user} = {
      isNormalUser = true;
      description = "Sridhar D Kedlaya";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "audio"
        "input"
        "uinput"
        "power"
        "docker"
        "libvirtd"
        "jackaudio"
        "kvm"
        "adbusers"
      ];
      # Login shell stays plain pkgs.zsh (added to /etc/shells by programs.zsh.enable).
      # The wrapped zsh (self.packages.*.zsh) is invoked by alacritty as its child shell.
      shell = pkgs.zsh;
      packages = with pkgs; [
        alejandra
        neovim

        firefox
        inputs.zen-browser.packages.${system}.default

        emacs-lsp-booster
        ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [epkgs.vterm]))

        fuzzel
        wl-clipboard
        swww
        pulsemixer
        fastfetch
        brightnessctl
        viewnior
        swaylock
        swayidle

        ripgrep
        fd
        bat
        eza
        zoxide
        fzf
        direnv
        jujutsu

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

        vscode
        nodejs_22
        elan
        processing
        godot
        blender

        bottom
        jq
        socat
        hck
        tlrc
        sl
        copyq
        element-desktop
        mgba
        ueberzugpp
        pandoc
        texliveFull
        enchant
        yazi

        noto-fonts-color-emoji
        nerd-fonts.fira-code
        nerd-fonts.droid-sans-mono
        nerd-fonts.monaspace
        nerd-fonts.mononoki

        # ── Wrapped programs (perSystem.packages.*) ──────────────────────────
        # Each is a wrapPackage/wrapperModules derivation with config embedded.
        self.packages.${system}.zsh # ZDOTDIR → managed .zshrc in nix store
        self.packages.${system}.alacritty # --config-file + shell = wrapped zsh
        self.packages.${system}.git # GIT_CONFIG_GLOBAL → managed gitconfig
        self.packages.${system}.mako # --config= → managed mako.ini
        self.packages.${system}.sioyek # XDG_CONFIG_HOME → managed sioyek dir
      ];
    };

    environment.systemPackages = [pkgs.docker-compose];

    system.stateVersion = "23.11";
  };
}
