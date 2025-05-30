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
    inputs.nix-index-database.hmModules.nix-index
    inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger
    inputs.nvchad4nix.homeManagerModule
    inputs.hyprland.homeManagerModules.default
    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./features/mako.nix
    ./features/hyprland.nix
    ./features/nvim.nix
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
      inputs.nur.overlays.default
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

  # programs.neovim = {
  #   enable = true;
  #   extraLuaConfig = ''
  #     vim.api.nvim_set_keymap('i', 'kj', '<Esc>', { noremap = true, silent = true })
  #   '';
  # };

  programs.eww = {
    enable = true;
    configDir = ./filthy;
  };

  xdg.enable = true;

  qt = {
    enable = true;
  };

  gtk = {
    enable = true;

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
    foliate

    nur.repos.nltch.spotify-adblock

    alejandra

    taskwarrior3
    taskwarrior-tui

    floorp
    firefox

    grimblast
    screenshot

    mako
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
    # udiskie
    bottom
    # cava
    mpv
    # wl-mirror

    bc
    battery-health

    ripgrep
    fd

    tlrc
    sl
    zsh-fzf-tab
    copyq
    inputs.zen-browser.packages."${system}".default

    pass-wayland
    gnupg
    pinentry-qt
    pass-show
    # (import ./derivations/pass.nix {inherit pkgs;})

    at
    # alarm

    # airshipper
    # veloren

    # calibre
    # libreoffice-fresh
    libqalculate
    transmission_4-qt
    # mcomix

    jq
    socat
    hck

    # halloy
    # telegram-desktop
    # blender

    # neo4j

    # android-studio
    # android-studio-tools
    # jdk
    # chromium

    # quantum-espresso
    # mininet

    emacs
    obsidian
    # logseq

    enchant
    nodejs_22

    # speedtest-rs
    # porsmo

    vscode
    amfora
    wireplumber

    nemo-with-extensions
    yazi

    klavaro

    mgba
    ueberzugpp

    rnote

    pandoc
    # protonvpn-cli_2

    texliveFull

    noto-fonts-emoji
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.monaspace
    nerd-fonts.mononoki

    # anki-bin

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
    delta = {
      enable = true;
      package = pkgs.delta;
      options = {
        navigate = true;
        dark = true;
      };
    };
    extraConfig = {
      core = {
        compression = 9;
        whitespace = "error";
        preloadindex = true;
      };
      advice = {
        addEmptyPathspec = false;
        pushNonFastForward = false;
        statusHints = false;
      };
      url."git@github.com:DeathStroke19891/" = {
        insteadOf = "ds:";
      };
      url."git@github.com:" = {
        insteadOf = "gh:";
      };
      # url."ssh://git@github.com/" = {
      #   insteadOf = "https://github.com/";
      # };
      init = {
        defaultBranch = "dev";
      };
      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = "all";
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      interactive = {
        singlekey = true;
      };
      diff = {
        context = 3;
        renames = "copies";
        interHunkContext = 10;
      };
      commit = {
        verbose = true;
      };
      push = {
        autoSetupRemote = true;
        default = "current";
        followTags = true;
      };
      pull = {
        default = true;
        rebase = true;
      };
      rebase = {
        autoStash = true;
        missingCommitsCheck = "warn";
      };
      log = {
        abbrevCommit = true;
        graphColors = "blue,yellow,cyan,magenta,green,red";
      };
      color."decorate" = {
        HEAD = "red";
        branch = "blue";
        tag = "yellow";
        remoteBranch = "magenta";
      };
      color."branch" = {
        current = "magenta";
        local = "default";
        remote = "yellow";
        upstream = "green";
        plain = "blue";
      };
      branch = {
        sort = "-committerdate";
      };
      tag = {
        sort = "-taggerdate";
      };
      pager = {
        branch = false;
        tag = false;
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

      gs = "git status --short";
      gd = "git diff --output-indicator-new=' ' --output-indicator-old=' '";
      gds = "git diff --staged";
      ga = "git add";
      gap = "git add --patch";
      gc = "git commit";
      gp = "git push";
      gu = "git pull";
      gl = "git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an %ar%C(auto) %D%n%s%n'";
      gb = "git branch";
      gi = "git init";
      gcl = "git clone";
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
      PATH=$HOME/Android/Sdk/platform-tools/:$PATH
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


      fpath=(${pkgs.trashy}/share/zsh/site-functions \
             $fpath)
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
