{
  inputs,
  self,
  ...
}: {
  flake.wrappersModules.zsh = {
    config,
    pkgs,
    lib,
    wlib,
    ...
  }: {
    zshAliases = {
      ll = "eza -l";
      ls = "eza";
      cat = "bat";
      cd = "z";
      vim = "nvim";
      update = "sudo nixos-rebuild switch --flake ~/flake_firestorm/";
    };

    env = {
      EDITOR = "nvim";
      STEAM_APP_DIR = "$HOME/.local/share/Steam/steamapps/common/";
      LEDGER_FILE = "$HOME/parallaxa/main.journal";
      LSP_USE_PLISTS = "true";
    };

    runtimePkgs = with pkgs; [
      oh-my-zsh
      zsh-powerlevel10k
      zsh-syntax-highlighting
      fzf
      zoxide
      eza
      jujutsu
    ];

    zshrc.content = ''
      # History
      HISTSIZE=10000
      SAVEHIST=10000
      setopt SHARE_HISTORY
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_FIND_NO_DUPS

      # Keymap
      bindkey -e

      # Completion
      autoload -Uz compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu select

      # Oh-my-zsh
      export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"
      plugins=(sudo colored-man-pages git git-commit)
      source "$ZSH/oh-my-zsh.sh"

      # Powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Syntax highlighting
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

      # Keybinds
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      # Integrations
      eval "$(${lib.getExe pkgs.fzf} --zsh)"
      eval "$(${lib.getExe pkgs.zoxide} init zsh)"

      # FZF tab previews
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza $realpath'

      # Completions
      source <(${pkgs.jujutsu}/bin/jj util completion --zsh)

      # PATH
      export PATH="$HOME/Android/Sdk/platform-tools/:$PATH"

      # p10k
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
  };

  perSystem = {pkgs, ...}: {
    packages.zsh = inputs.wrapper-modules.wrappers.zsh.wrap {
      inherit pkgs;
      imports = [self.wrappersModules.zsh];
    };
  };
}
