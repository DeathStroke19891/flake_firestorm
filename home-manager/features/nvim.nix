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
}
