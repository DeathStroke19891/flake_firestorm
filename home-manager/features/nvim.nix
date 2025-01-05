{
  pkgs,
  config,
  ...
}: {
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
          "davidmh/mdx.nvim",
          config = true,
          lazy = false,
          dependencies = {"nvim-treesitter/nvim-treesitter"}
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
            math.randomseed(os.time())

            local alpha = require 'alpha'
            local dashboard = require 'alpha.themes.dashboard'

            -- Function to center quotes
            local function center_quote(quote)
              local max_width = 0
              for _, str in ipairs(quote) do
                max_width = math.max(max_width, #str)
              end

              local centered_strings = {}
              for _, str in ipairs(quote) do
                local leading_spaces = math.floor((max_width - #str) / 2)
                local trailing_spaces = max_width - leading_spaces - #str
                local centered_str = string.rep(' ', leading_spaces) .. str .. string.rep(' ', trailing_spaces)
                table.insert(centered_strings, centered_str)
              end

              -- Insert blank strings at start of table yea ik its scuffed
              table.insert(centered_strings, 1, ''')
              table.insert(centered_strings, 1, ''')
              return centered_strings
            end

            dashboard.section.header.val = {
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠐⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⡅⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢰⠘⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡉⠀⠴⠠⣒⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠒⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢰⡑⠌⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⢀⠙⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⣝⠂⠺⣿⣿⣿⣿⣿⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⢹⡛⠀⢸⣿⣿⣿⣿⠇⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡈⣇⠡⢸⣿⣿⣿⣿⢰⡘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢻⠀⠈⣿⣿⣿⣿⡄⢷⡜⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠸⡇⠀⢹⣿⣿⣿⣿⡌⠓⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⢷⠀⠘⣿⣿⡟⢻⠇⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢸⡆⠀⢿⣿⡇⡘⣠⡆⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣇⠀⢸⠟⣴⡁⠁⡇⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢩⣿⣇⠀⠉⠀⠈⢰⡏⢀⡀⣰⠇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⢸⣿⠋⡴⠀⠀⠀⣸⢠⣾⠰⣿⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⢡⠰⡙⣸⡇⢀⡀⣴⡿⠛⠿⢧⡙⢠⡇⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⣼⡿⠋⢹⣿⣿⣷⠆⠀⢈⣹⣿⠘⣷⡀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣣⡾⢋⣴⢿⣦⡻⣿⠏⠀⠠⣬⣿⣿⡶⠋⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⡏⢰⢟⣵⡿⢋⠸⣿⡿⢡⣶⣤⣿⢿⡿⠻⠖⣳⣦⡙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⡜⣉⣩⣵⡿⠷⣶⠆⢈⡿⠋⢐⣫⠤⢊⣾⠟⢰⣇⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⣿⣿⣿⡆⢀⡀⣠⣿⠏⢡⣶⠀⢈⣸⣼⠟⡋⠉⠁⢴⡿⢋⠂⣾⣿⣧⠰⠿⡏⠹⣿⣿⣿⣿⣿",
              "⣿⣿⣿⣿⣿⠟⠉⠉⠺⠟⠉⣿⣭⣠⡾⢋⣴⣿⣿⣿⡆⠀⠀⢴⠘⡇⢸⢰⠿⠿⣿⣦⠀⠶⣦⡛⢻⣿⣿⣿",
              "⣿⣿⠟⠋⠅⡀⠀⠀⢤⣤⣀⣀⠐⠈⢍⠉⠠⠄⢿⣿⠟⠀⠀⠩⠇⠗⠀⣀⣤⠄⠀⠉⠁⠁⣸⣿⣄⠻⣿⣿",
              "⣿⠁⡠⣀⣀⡉⠑⢦⡰⡝⢿⡟⢳⠀⠀⢀⣠⢀⡌⠃⠀⠀⠀⠁⠀⠘⠛⠛⠛⠀⠀⠒⠀⣾⣿⣿⠿⠷⠘⣿",
              "⡅⠚⡀⣁⣀⣀⣀⢀⣥⡴⠟⣐⠀⡶⡶⣄⣁⣤⡀⠀⣄⣀⡤⡴⠛⠐⠒⣂⣉⠁⠄⡀⠄⡀⣉⡤⠄⢀⡂⣻",
              ''',
              ''',
            }

            local quotes = {
              {
                'Dear, oh dear. What was it? The Hunt? The Blood? Or the horrible dream?',
                'Oh, it doesn\'t matter... It always comes down to the Hunter\'s helper to clean up after these sort of messes.',
                'Tonight, Gehrman joins the hunt...',
              },
            }

            dashboard.section.footer.val = center_quote(quotes[math.random(#quotes)])

            dashboard.section.buttons.val = {
              dashboard.button('b', '  > New File', ':Telescope find_files<CR>'),
              dashboard.button('f f', '  > Find file', ':Telescope find_files<CR>'),
              dashboard.button('q', '󰅚  > Quit NVIM', ':qa<CR>'),
            }

            alpha.setup(dashboard.opts)

            vim.cmd [[
                autocmd FileType alpha setlocal nofoldenable
            ]]

            vim.api.nvim_set_keymap('n', '<leader>h', ':Alpha<CR', { noremap = true, silent = true})
          end
        },
        {
          "folke/todo-comments.nvim",
          dependencies = { "nvim-lua/plenary.nvim" },
        },
        {
          "rebelot/kanagawa.nvim",
        },
        {
          "artanikin/vim-synthwave84"
        },
        {
          url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
          event = "VeryLazy",
          config = function()
            require("lsp_lines").setup()
            vim.diagnostic.config({
              virtual_text = false,
            })
          end,
        }
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
      vim.api.nvim_set_option("clipboard","unnamedplus")
      local options = { noremap = true }
      vim.keymap.set("i", "kj", "<Esc>", options)
    '';
  };
}
