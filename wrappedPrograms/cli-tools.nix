{...}: {
  perSystem = {pkgs, ...}: {
    packages.cli-tools = pkgs.symlinkJoin {
      name = "cli-tools";
      paths = with pkgs; [
        ripgrep
        fd
        bat
        eza
        zoxide
        fzf
        jq
        socat
        bottom
        hck
        tlrc
        ueberzugpp
      ];
    };
  };
}
