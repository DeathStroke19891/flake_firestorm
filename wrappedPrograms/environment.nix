{self, ...}: {
  perSystem = {
    pkgs,
    self',
    lib,
    ...
  }: {
    packages.environment = pkgs.runCommand "environment" {
      nativeBuildInputs = [pkgs.makeWrapper];
      meta.mainProgram = "zsh";
    } ''
      mkdir -p $out/bin
      makeWrapper ${self'.packages.zsh}/bin/zsh $out/bin/zsh \
        --prefix PATH : ${lib.makeBinPath [
          self'.packages.cli-tools
          self'.packages.dev-tools
          self'.packages.git
        ]}
    '';
  };
}
