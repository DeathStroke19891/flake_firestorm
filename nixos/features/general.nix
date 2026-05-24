{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.general = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      self.nixosModules.extra_hjem
      self.nixosModules.gtk
      self.nixosModules.nix
    ];


    users.users.${config.preferences.user.name} = {
      isNormalUser = true;
      description = "${config.preferences.user.name}'s account";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "audio"
        "input"
        "libvirtd"
        "kvm"
        "adbusers"
      ];
      shell = self.packages.${pkgs.stdenv.hostPlatform.system}.environment;
    };
  };
}

    environment.pathsToLink = ["/share/zsh"];
    programs.zsh.enable = true;

    services.xserver.xkb.layout = "us";
    services.gnome.gnome-keyring.enable = true;
    services.atd.enable = true;
    services.openssh.enable = true;
    services.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    systemd.user.services.emacs.environment = {
      LIBRARY_PATH =
        "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.glibc}/lib";
    };

    environment.systemPackages = with pkgs; [
      vim
      wget
      ntfs3g
      ntfsprogs
      xdg-utils
      psmisc
      dbus
      wireplumber
      cachix
      gcc
      binutils
    ];

      packages = with pkgs; [
        alejandra
        neovim

        firefox
        inputs.zen-browser.packages.${system}.default

        emacs-lsp-booster
        ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [epkgs.vterm]))

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
        nemo
        nyxt

        self.packages.${system}.zsh
        self.packages.${system}.git
        self.packages.${system}.sioyek
      ];
    };
