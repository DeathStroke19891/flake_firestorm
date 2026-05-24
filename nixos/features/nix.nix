{ inputs, ... }: {
  flake.nixosModules.nix = {
    lib,
    config,
    pkgs,
    ...
  }: {
    imports = [
      inputs.nix-index-database.nixosModules.nix-index
    ];

    programs.nix-index-database.comma.enable = true;

    nixpkgs.config.allowUnfree = true;

    programs.nix-ld.enable = true;

    nix = let
      flakeInputs =
        lib.filterAttrs (_: lib.isType "flake") inputs;
    in {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        flake-registry = "";

        nix-path = config.nix.nixPath;

        substituters = [
          "https://cache.nixos.org/"
        ];
      };

      channel.enable = false;

      registry =
        lib.mapAttrs (_: flake: { inherit flake; })
        flakeInputs;

      nixPath =
        lib.mapAttrsToList
        (n: _: "${n}=flake:${n}")
        flakeInputs;
    };

    programs.direnv = {
      enable = true;

      silent = false;

      loadInNixShell = true;

      nix-direnv.enable = true;
    };

    environment.systemPackages = with pkgs; [
      alejandra
      statix
      nixd
    ];
  };
}
