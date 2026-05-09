# Nix daemon settings: flakes, registry pinning, binary caches, direnv, nix-index.
{inputs, ...}: {
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
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in {
      settings = {
        experimental-features = "nix-command flakes";
        # Disable global registry in favour of per-flake pinned registry below
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
        substituters = [
          "https://cache.nixos.org/"
        ];
      };
      # Keep channels disabled; inputs provide all packages
      channel.enable = false;
      # Pin registry and nix path to flake inputs for reproducibility
      registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

    programs.direnv = {
      enable = true;
      silent = false;
      loadInNixShell = true;
      nix-direnv.enable = true;
    };
  };
}
