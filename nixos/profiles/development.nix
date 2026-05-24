{self, ...}: {
  flake.nixosModules.profile-development = {pkgs, ...}: {
    imports = [
      self.nixosModules.nix
      self.nixosModules.shell-environment
    ];

    services.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
    };

    systemd.user.services.emacs.environment = {
      LIBRARY_PATH =
        "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.glibc}/lib";
    };

    environment.systemPackages = with pkgs; [
      emacs-lsp-booster
      ((emacsPackagesFor emacs-pgtk).emacsWithPackages (epkgs: [epkgs.vterm]))

      nodejs_22
      elan
      processing
      godot
      blender
      vscode

      pandoc
      texliveFull
      enchant
    ];
  };
}
