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
          cd = "z";
          vim = "nvim";
          update = "sudo nixos-rebuild switch --flake ~/flake_firestorm/";
        };

        completion = {
          enable = true;
          caseInsensitive = true;
          colors = true;
          fuzzySearch = true;
        };

        autoSuggestions.enable = true;

        integrations = {
          fzf.enable = true;
          zoxide.enable = true;
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

      extraRC = ''
        export ZSH="${config.pkgs.oh-my-zsh}/share/oh-my-zsh"
        plugins=(sudo colored-man-pages git git-commit)
        source "$ZSH/oh-my-zsh.sh"

        source ${config.pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

        source ${config.pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward

        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza $realpath'

        source <(${config.pkgs.jujutsu}/bin/jj util completion --zsh)

        export EDITOR="nvim"
        export STEAM_APP_DIR="$HOME/.local/share/Steam/steamapps/common/"
        export LEDGER_FILE="$HOME/parallaxa/main.journal"
        export LSP_USE_PLISTS="true"
        export PATH="$HOME/Android/Sdk/platform-tools/:$PATH"

        [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
      '';
    };
  };

  perSystem = {pkgs, ...}: {
    packages.zsh = inputs.wrapper-modules.wrappers.zsh.wrap {
      inherit pkgs;
      imports = [self.wrappersModules.zsh];
    };
  };
}
