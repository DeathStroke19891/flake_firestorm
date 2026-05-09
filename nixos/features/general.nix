{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.general = {
    config,
    pkgs,
    ...
  }: let
    user = config.preferences.user.name;
    system = pkgs.stdenv.hostPlatform.system;
  in {
    imports = [
      self.nixosModules.extra_hjem
      self.nixosModules.gtk
      self.nixosModules.nix
    ];

    environment.pathsToLink = ["/share/zsh"];
    programs.zsh.enable = true;

    services.xserver.xkb.layout = "us";
    services.gnome.gnome-keyring.enable = true;
    services.atd.enable = true;
    services.openssh.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

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
    ];

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
      shell = pkgs.zsh;
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
        yazi

        # ── Wrapped programs ──────────────────────────────────────────────────
        self.packages.${system}.zsh
        self.packages.${system}.git
        self.packages.${system}.sioyek
      ];
    };
  };
}
