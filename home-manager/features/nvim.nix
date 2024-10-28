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
        # {
        #   'xeluxee/competitest.nvim',
        #   dependencies = 'MunifTanjim/nui.nvim',
        #   config = function() require('competitest').setup() end,
        # },
        {
          "davidmh/mdx.nvim",
          config = true,
          dependencies = {"nvim-treesitter/nvim-treesitter"}
        },
        # {
        #   'neovim/nvim-lspconfig',
        #   config = function()
        #
        #     local lspconfig = require "lspconfig"
        #     local capabilities = require('cmp_nvim_lsp').default_capabilities()
        #
        #     lspconfig.rust_analyzer.setup{
        #       capabilities = capabilities,
        #       filetypes = {"rust"},
        #       root_dir = lspconfig.util.root_pattern("Cargo.toml"),
        #       settings = {
        #         ['rust_analyzer'] = {
        #           diagnostics = {
        #             enable = false;
        #           }
        #         }
        #       }
        #     }
        #
        #     lspconfig.pylsp.setup{
        #       capabilities = capabilities,
        #       filetypes = {"python"},
        #       settings = {
        #         pylsp = {
        #           plugins = {
        #             pycodestyle = {
        #               ignore = {'W391'},
        #               maxLineLength = 80
        #             }
        #           }
        #         }
        #       }
        #     }
        #
        #     lspconfig.nixd.setup{
        #       capabilities = capabilities,
        #     }
        #
        #     lspconfig.clangd.setup{
        #       capabilities = capabilities,
        #       filetypes = { "c", "cpp"},
        #     }
        #
        #   end,
        # },
        # {
        #   'nvimtools/none-ls.nvim',
        #   event = "VeryLazy",
        #   opts = function()
        #     local null_ls = require("null-ls")
        #     local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        #
        #     local opts = {
        #       sources = {
        #         null_ls.builtins.formatting.clang_format,
        #       },
        #       on_attach = function(client, bufnr)
        #           if client.supports_method("textDocument/formatting") then
        #               vim.api.nvim_clear_autocmds({
        #                 group = augroup,
        #                 buffer = bufnr
        #               })
        #               vim.api.nvim_create_autocmd("BufWritePre", {
        #                   group = augroup,
        #                   buffer = bufnr,
        #                   callback = function()
        #                     vim.lsp.buf.format({ async = false })
        #                   end
        #               })
        #           end
        #       end,
        #     }
        #
        #     return opts
        #   end,
        # },
        # {
        #   'mfussenegger/nvim-dap',
        #   config = function()
        #     local dap = require('dap')
        #
        #     dap.adapters.codelldb = {
        #       type = 'server',
        #       host = '127.0.0.1',
        #       port = 13241,
        #       executable = {
        #         command = '${pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter}/bin/codelldb',
        #         args = {"--port", "''${port}"},
        #       }
        #     }
        #
        #     dap.configurations.cpp = {
        #         {
        #           name = "Launch file",
        #           type = "codelldb",
        #           request = "launch",
        #           program = function()
        #             return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        #           end,
        #           cwd = "''${workspaceFolder}",
        #           stopOnEntry = false,
        #         },
        #     }
        #   end
        # },
        # {
        #   'hrsh7th/nvim-cmp',
        #   config = function()
        #     local cmp = require'cmp'
        #
        #     cmp.setup({
        #       snippet = {
        #         expand = function(args)
        #           require('luasnip').lsp_expand(args.body)
        #         end,
        #       },
        #       window = {
        #         completion = cmp.config.window.bordered(),
        #         documentation = cmp.config.window.bordered(),
        #       },
        #       mapping = cmp.mapping.preset.insert({
        #         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        #         ['<C-f>'] = cmp.mapping.scroll_docs(4),
        #         ['<C-Space>'] = cmp.mapping.complete(),
        #         ['<C-e>'] = cmp.mapping.abort(),
        #         ['<CR>'] = cmp.mapping.confirm({ select = true }),
        #         ["<Tab>"] = cmp.mapping(function(fallback)
        #                         local status_ok, luasnip = pcall(require, "luasnip")
        #                         if status_ok and luasnip.expand_or_jumpable() then
        #                             luasnip.expand_or_jump()
        #                         else
        #                             fallback()
        #                         end
        #                     end, { "i", "s" }),
        #         ["<S-Tab>"] = cmp.mapping(function(fallback)
        #             local status_ok, luasnip = pcall(require, "luasnip")
        #             if status_ok and luasnip.jumpable(-1) then
        #                 luasnip.jump(-1)
        #             else
        #                 fallback()
        #             end
        #         end, { "i", "s" })
        #       }),
        #       sources = cmp.config.sources({
        #         -- { name = 'nvim_lsp' },
        #         { name = 'luasnip' },
        #       }, {
        #         { name = 'buffer' },
        #       })
        #     })
        #   end
        # },
        # {
        #   'L3MON4D3/LuaSnip',
        #   dependencies = 'saadparwaiz1/cmp_luasnip',
        # },
        # {
        #   'hrsh7th/cmp-nvim-lsp',
        # },
        # {
        #   "goolord/alpha-nvim",
        #   lazy = false;
        #   dependencies = {"kyazdani42/nvim-web-devicons"},
        #   config = function()
        #     local alpha = require("alpha")
        #     local dashboard = require("alpha.themes.dashboard")
        #
        #     math.randomseed(os.time())
        #
        #     local function pick_color()
        #         local colors = {"String", "Identifier", "Keyword", "Number"}
        #         return colors[math.random(#colors)]
        #     end
        #
        #     local function footer()
        #         -- local total_plugins = #vim.tbl_keys(packer_plugins)
        #         local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
        #         local version = vim.version()
        #         local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
        #
        #         return datetime .. "   " .. nvim_version_info
        #     end
        #
        #     local logo = {
        #       "                                   ",
        #       "                                   ",
        #       "                                   ",
        #       "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
        #       "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
        #       "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
        #       "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
        #       "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
        #       "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
        #       "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
        #       " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
        #       " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
        #       "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
        #       "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
        #       "                                   ",
        #     }
        #
        #     dashboard.section.header.val = logo
        #     dashboard.section.header.opts.hl = pick_color()
        #
        #     dashboard.section.buttons.val= {
        #       dashboard.button('e', 'ﱐ  New file', leader, '<cmd>ene<CR>'),
        #       dashboard.button('s', '  Sync plugins' , leader, '<cmd>Lazy Sync<CR>'),
        #       dashboard.button('c', '  Configurations', leader, '<cmd>e ~/flake_firestorm/home-manager/features/nvim.nix<CR>'),
        #       dashboard.button('<leader>'.. ' f f', '  Find files', leader, '<cmd>Telescope find_files<CR>'),
        #       dashboard.button('<leader>' .. ' fof', '  Find old files', leader, '<cmd>Telescope oldfiles<CR>'),
        #       dashboard.button('<leader>' .. ' f ;', 'ﭨ  Live grep', leader, '<cmd>Telescope live_grep<CR>'),
        #       dashboard.button('<leader>' .. ' f g', '  Git status', leader, '<cmd>Telescope git_status<CR>'),
        #       dashboard.button('<leader>' .. '   q', '  Quit' , leader, '<cmd>qa<CR>')
        #     }
        #
        #     dashboard.section.footer.val = footer()
        #     dashboard.section.footer.opts.hl = "Constant"
        #
        #     alpha.setup(dashboard.opts)
        #
        #     vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
        #   end
        # },
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
}
