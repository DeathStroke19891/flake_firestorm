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

  # programs.neovim = {
  #   enable = true;
  #   extraLuaConfig = ''
  #     vim.api.nvim_set_keymap('i', 'kj', '<Esc>', { noremap = true, silent = true })
  #   '';
  # };

  programs.nvchad = {
    enable = true;
    backup = false;
    extraPlugins = ''
      return {
        {
          'xeluxee/competitest.nvim',
          dependencies = 'MunifTanjim/nui.nvim',
          config = function() require('competitest').setup() end,
        },
        {
          'neovim/nvim-lspconfig',
          config = function()

            local lspconfig = require "lspconfig"
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            lspconfig.rust_analyzer.setup{
              capabilities = capabilities,
              filetypes = {"rust"},
              root_dir = lspconfig.util.root_pattern("Cargo.toml"),
              settings = {
                ['rust_analyzer'] = {
                  diagnostics = {
                    enable = false;
                  }
                }
              }
            }

            lspconfig.pylsp.setup{
              capabilities = capabilities,
              filetypes = {"python"},
              settings = {
                pylsp = {
                  plugins = {
                    pycodestyle = {
                      ignore = {'W391'},
                      maxLineLength = 80
                    }
                  }
                }
              }
            }

            lspconfig.nixd.setup{
              capabilities = capabilities,
            }

            lspconfig.clangd.setup{
              capabilities = capabilities,
              filetypes = { "c", "cpp"},
            }

          end,
        },
        {
          'nvimtools/none-ls.nvim',
          event = "VeryLazy",
          opts = function()
            local null_ls = require("null-ls")
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            local opts = {
              sources = {
                null_ls.builtins.formatting.clang_format,
              },
              on_attach = function(client, bufnr)
                  if client.supports_method("textDocument/formatting") then
                      vim.api.nvim_clear_autocmds({
                        group = augroup,
                        buffer = bufnr
                      })
                      vim.api.nvim_create_autocmd("BufWritePre", {
                          group = augroup,
                          buffer = bufnr,
                          callback = function()
                            vim.lsp.buf.format({ async = false })
                          end
                      })
                  end
              end,
            }

            return opts
          end,
        },
        {
          'mfussenegger/nvim-dap',
          config = function()
            local dap = require('dap')

            dap.adapters.codelldb = {
              type = 'server',
              host = '127.0.0.1',
              port = 13241,
              executable = {
                command = '${pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter}/bin/codelldb',
                args = {"--port", "''${port}"},
              }
            }

            dap.configurations.cpp = {
                {
                  name = "Launch file",
                  type = "codelldb",
                  request = "launch",
                  program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                  end,
                  cwd = "''${workspaceFolder}",
                  stopOnEntry = false,
                },
            }
          end
        },
        {
          'hrsh7th/nvim-cmp',
          config = function()
            local cmp = require'cmp'

            cmp.setup({
              snippet = {
                expand = function(args)
                  require('luasnip').lsp_expand(args.body)
                end,
              },
              window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
              },
              mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                                local status_ok, luasnip = pcall(require, "luasnip")
                                if status_ok and luasnip.expand_or_jumpable() then
                                    luasnip.expand_or_jump()
                                else
                                    fallback()
                                end
                            end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    local status_ok, luasnip = pcall(require, "luasnip")
                    if status_ok and luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" })
              }),
              sources = cmp.config.sources({
                -- { name = 'nvim_lsp' },
                { name = 'luasnip' },
              }, {
                { name = 'buffer' },
              })
            })
          end
        },
        {
          'L3MON4D3/LuaSnip',
          dependencies = 'saadparwaiz1/cmp_luasnip',
        },
        {
          'hrsh7th/cmp-nvim-lsp',
        },
        {
          "goolord/alpha-nvim",
          lazy = false;
          dependencies = {"kyazdani42/nvim-web-devicons"},
          config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            math.randomseed(os.time())

            local function pick_color()
                local colors = {"String", "Identifier", "Keyword", "Number"}
                return colors[math.random(#colors)]
            end

            local function footer()
                -- local total_plugins = #vim.tbl_keys(packer_plugins)
                local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
                local version = vim.version()
                local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

                return datetime .. "   " .. nvim_version_info
            end

            local logo = {
              "                                   ",
              "                                   ",
              "                                   ",
              "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
              "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
              "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
              "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
              "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
              "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
              "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
              " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
              " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
              "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
              "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
              "                                   ",
            }

            dashboard.section.header.val = logo
            dashboard.section.header.opts.hl = pick_color()

            dashboard.section.buttons.val= {
              dashboard.button('e', 'ﱐ  New file', leader, '<cmd>ene<CR>'),
              dashboard.button('s', '  Sync plugins' , leader, '<cmd>Lazy Sync<CR>'),
              dashboard.button('c', '  Configurations', leader, '<cmd>e ~/flake_firestorm/home-manager/features/nvim.nix<CR>'),
              dashboard.button('<leader>'.. ' f f', '  Find files', leader, '<cmd>Telescope find_files<CR>'),
              dashboard.button('<leader>' .. ' fof', '  Find old files', leader, '<cmd>Telescope oldfiles<CR>'),
              dashboard.button('<leader>' .. ' f ;', 'ﭨ  Live grep', leader, '<cmd>Telescope live_grep<CR>'),
              dashboard.button('<leader>' .. ' f g', '  Git status', leader, '<cmd>Telescope git_status<CR>'),
              dashboard.button('<leader>' .. '   q', '  Quit' , leader, '<cmd>qa<CR>')
            }

            dashboard.section.footer.val = footer()
            dashboard.section.footer.opts.hl = "Constant"

            alpha.setup(dashboard.opts)

            vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
          end
        },
        {
          "davidmh/mdx.nvim",
          config = true,
          dependencies = {"nvim-treesitter/nvim-treesitter"}
        },
      }
    '';

    extraPackages = with pkgs; [
      nixd
      rust-analyzer
      clang-tools
      vscode-extensions.vadimcn.vscode-lldb.adapter
      (python3.withPackages (ps:
        with ps; [
          python-lsp-server
        ]))
    ];

    extraConfig = ''
      vim.opt.colorcolumn = "80"
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
    foliate

    nur.repos.nltch.spotify-adblock

    alejandra

    floorp
    firefox
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

    halloy
    telegram-desktop
    blender

    # android-studio
    # android-studio-tools
    jdk
    chromium

    emacs
    obsidian
    zed-editor

    enchant
    nodejs_22

    tig
    act
    speedtest-rs
    porsmo

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
