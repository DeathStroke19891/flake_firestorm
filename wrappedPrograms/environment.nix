{
  self,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    lib,
    ...
  }: let
    nuConfig = pkgs.writeText "config.nu" ''
      $env.config = {
        show_banner: false
      }

      # Aliases
      alias ll = eza -l
      alias ls = eza
      alias cat = bat
      alias vim = nvim
      alias update = sudo nixos-rebuild switch --flake ~/flake_firestorm/
    '';

    nuEnv = pkgs.writeText "env.nu" ''
      $env.EDITOR = "nvim"
      $env.STEAM_APP_DIR = $"($env.HOME)/.local/share/Steam/steamapps/common/"
      $env.LEDGER_FILE = $"($env.HOME)/parallaxa/main.journal"
      $env.LSP_USE_PLISTS = "true"
      $env.PATH = ($env.PATH | split row (char esep)
        | prepend $"($env.HOME)/Android/Sdk/platform-tools")
    '';
  in {
    packages.environment = pkgs.runCommand "nu-environment" {
      nativeBuildInputs = [pkgs.makeWrapper];
      meta.mainProgram = "nu";
      passthru.shellPath = "/bin/nu";
    } ''
      mkdir -p $out/bin
      makeWrapper ${lib.getExe pkgs.nushell} $out/bin/nu \
        --add-flags "--config ${nuConfig}" \
        --add-flags "--env-config ${nuEnv}" \
        --prefix PATH : ${lib.makeBinPath [
          self'.packages.cli-tools
          self'.packages.dev-tools
          self'.packages.git
        ]}
    '';
  };
}
