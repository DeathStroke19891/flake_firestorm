{...}: {
  perSystem = {pkgs, ...}: {
    packages.dev-tools = pkgs.symlinkJoin {
      name = "dev-tools";
      paths = with pkgs; [
        alejandra
        statix
        nixd
        direnv
        jujutsu
        neovim
      ];
    };
  };
}
