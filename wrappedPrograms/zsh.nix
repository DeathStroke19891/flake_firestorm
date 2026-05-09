# Zsh: mirrors vimjoyer's fish setup — uses Lassulus wrapperModules.zsh which
# sets ZDOTDIR to a nix-store directory containing .zshrc + .zshenv.
#
# The wrappersModules.zsh module uses config.pkgs (= perSystem pkgs) so all
# plugin store paths are baked into the managed .zshrc at build time.
#
# NOTE: programs.direnv.enable = true in nixos/features/nix.nix already injects
# `eval "$(direnv hook zsh)"` into /etc/zshrc — do NOT add it here again.
{
  inputs,
  self,
  ...
}: {
  flake.wrappersModules.zsh = {config, ...}: {
    config = {
      settings = {
        keyMap = "emacs";

        shellAliases = {
          ll = "eza -l";
          ls = "eza";
          cat = "bat";
          cd = "z"; # zoxide replaces cd
          vim = "nvim";
          update = "sudo nixos-rebuild switch --flake ~/flake_firestorm/";
        };

        completion = {
          enable = true;
          caseInsensitive = true;
          colors = true; # zstyle list-colors via LS_COLORS
          fuzzySearch = true; # enables fzf-tab + zstyle menu no
        };

        autoSuggestions.enable = true;

        integrations = {
          fzf.enable = true; # source <(fzf --zsh) + adds fzf to PATH
          zoxide.enable = true; # eval "$(zoxide init zsh)" + adds zoxide to PATH
        };

        history = {
          size = 10000;
          save = 10000;
          share = true;
          ignoreAllDups = true;
          ignoreDups = true;
          ignoreSpace = true;
          saveNoDups = true;
          findNoDups = true;
        };
      };

      # Appended after the module-generated block in .zshrc.
      # Uses config.pkgs (= the pkgs passed in perSystem) for all store paths.
      extraRC = ''
        # oh-my-zsh (plugins only — no theme; p10k used instead)
        export ZSH="${config.pkgs.oh-my-zsh}/share/oh-my-zsh"
        plugins=(sudo colored-man-pages git git-commit)
        source "$ZSH/oh-my-zsh.sh"

        # Powerlevel10k theme (must come after oh-my-zsh)
        source ${config.pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

        # Syntax highlighting (must come last among plugins)
        source ${config.pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        # History search on Ctrl-P / Ctrl-N
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward

        # fzf-tab previews for cd and zoxide
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza $realpath'

        # jujutsu completions
        source <(${config.pkgs.jujutsu}/bin/jj util completion --zsh)

        # User environment variables
        export EDITOR="nvim"
        export STEAM_APP_DIR="$HOME/.local/share/Steam/steamapps/common/"
        export LEDGER_FILE="$HOME/parallaxa/main.journal"
        export LSP_USE_PLISTS="true"
        export PATH="$HOME/Android/Sdk/platform-tools/:$PATH"

        # Powerlevel10k instant-prompt config (user-managed, not in store)
        [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
      '';
    };
  };

  perSystem = {pkgs, ...}: {
    packages.zsh = (inputs.wrappers.wrapperModules.zsh.apply {
      inherit pkgs;
      imports = [self.wrappersModules.zsh];
    }).wrapper;
  };
}
