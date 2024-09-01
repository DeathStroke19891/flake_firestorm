{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    inputs.nix-colors.homeManagerModules.default
    inputs.xremap-flake.homeManagerModules.default
    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./features/mako.nix
    ./features/hyprland.nix
    ./features/alacritty.nix
    ./features/hyprlock.nix
    ./features/hypridle.nix
    ./features/hyprshade.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      inputs.nur.overlay
      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  services.xremap = {
    enable = true;
    withWlroots = true;
    config = {
      modmap = [
        {
          name = "main remaps";
          remap = {
            "rightalt" = "rightmeta";
            CapsLock = {
              held = "leftctrl";
              alone = "esc";
              alone_timeout_millis = 150;
            };
          };
        }
      ];
    };
  };

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    clock24 = true;
    sensibleOnTop = false;
    shell = "\\${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    customPaneNavigationAndResize = true;
    mouse = true;
    newSession = true;
    keyMode = "vi";
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.tmux-fzf
      {
        plugin = tmuxPlugins.power-theme;
        extraConfig = ''
          set -g @tmux_power_theme 'moon'
        '';
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contens 'on'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
    ];
    extraConfig = ''
      unbind %
      bind | split-window -h
      unbind '"'
      bind - split-window -v

      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      bind -r m resize-pane -Z

      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection

      unbind -T copy-mode-vi MouseDragEnd1Pane
    '';
  };

  programs.eww = {
    enable = true;
    configDir = ./filthy;
  };

  xdg.enable = true;

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      name = "qt5ct-style";
      package = pkgs.catppuccin-qt5ct;
    };
  };

  # catppuccin.flavor = "mocha";

  gtk = {
    enable = true;

    # catppuccin = {
    #   enable = true;
    #   accent = "lavender";
    #   size = "standard";
    # };

    cursorTheme.package = pkgs.phinger-cursors;
    cursorTheme.name = "phinger-cursors-dark";

    iconTheme.package = pkgs.candy-icons;
    iconTheme.name = "candy-icons";
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    sioyek

    nur.repos.nltch.spotify-adblock

    alejandra

    floorp
    firefox
    ladybird
    thunderbird
    pika-backup

    grimblast
    screenshot
    # (import ./derivations/screenshot.nix {inherit pkgs;})

    mako
    kooha
    rofi-wayland
    wl-clipboard
    swww
    pulsemixer
    fastfetch
    hyprcursor
    trashy
    viewnior
    hypridle
    hyprlock
    udiskie
    bottom
    cava
    hyprpicker
    mpv
    wl-mirror

    bc
    battery-health
    # (import ./derivations/battery-health.nix {inherit pkgs;})

    ripgrep
    fd
    tlrc
    sl
    zsh-fzf-tab
    copyq
    pstree

    pass-wayland
    gnupg
    pinentry-qt
    pass-show
    # (import ./derivations/pass.nix {inherit pkgs;})

    at
    alarm
    # (import ./derivations/alarm.nix {inherit pkgs;})

    calibre
    libreoffice-fresh
    libqalculate
    transmission_4-qt
    gimp
    planify
    bookworm
    # mcomix

    jq
    socat
    hck

    android-studio
    android-studio-tools
    jdk22
    chromium

    emacs
    neovim
    obsidian
    zed-editor

    enchant
    nodejs_22
    pyright
    clang-tools
    tig
    act
    speedtest-cli

    vscode
    amfora
    wireplumber

    catppuccin-qt5ct
    nemo-with-extensions
    yazi
    #ueberzugpp

    rnote

    pandoc
    protonvpn-cli_2

    texliveFull

    noto-fonts-emoji
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono" "Monaspace" "Mononoki"];})

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    STEAM_APP_DIR = "/home/parzival/.local/share/Steam/steamapps/common/";
  };

  programs.home-manager.enable = true;

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  programs.git = {
    enable = true;
    userName = "Sridhar D Kedlaya";
    userEmail = "sridhardked@gmail.com";
    aliases = {
      lg1 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
      lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
      lg = "lg2";
    };
    # delta = {
    #   enable = true;
    #   package =
    # };
    extraConfig = {
      delta = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
        syntax-highlighting = true;
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
    };
  };

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";

    shellAliases = {
      ll = "eza -l";
      update = "sudo nixos-rebuild switch --flake ~/flake_firestorm/";
      home-update = "home-manager switch";
      cd = "z";
      ls = "eza";
      rm = "trash -c always put";
      cat = "bat";
    };

    oh-my-zsh = {
      enable = true;
      plugins = ["sudo" "colored-man-pages"];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    history = {
      share = true;
      ignoreSpace = true;
      ignoreDups = true;
      ignoreAllDups = true;
    };

    initExtra = ''
      HISTDUP=erase
      setopt HIST_FIND_NO_DUPS
      setopt HIST_SAVE_NO_DUPS

      source ~/.p10k.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'exa $realpath'
    '';
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
  };

  programs.hyprcursor-phinger.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux = {
      enableShellIntegration = true;
    };
  };

  home.username = "parzival";
  home.homeDirectory = "/home/parzival";

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11";
}
