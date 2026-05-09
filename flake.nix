{
  description = "Flake Firestorm";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # flake-parts: the framework used to structure this flake
    # Every .nix file (except flake.nix and _-prefixed files) is auto-imported
    flake-parts.url = "github:hercules-ci/flake-parts";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake.url = "github:xremap/nix-flake";

    # Package wrapping: Lassulus/wrappers for wrapPackage + pre-built wrapper modules
    wrappers.url = "github:Lassulus/wrappers";

    # BirdeeHub/nix-wrapper-modules: flake-parts integration + additional pre-built modules
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
  };

  # Import all .nix files from current directory recursively,
  # excluding flake.nix itself and any file prefixed with `_`.
  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    inherit (lib.fileset) toList fileFilter;

    isNixModule = file:
      file.hasExt "nix"
      && file.name != "flake.nix"
      && !lib.hasPrefix "_" file.name;

    importTree = path:
      toList (fileFilter isNixModule path);

    mkFlake = inputs.flake-parts.lib.mkFlake {inherit inputs;};
  in
    mkFlake {imports = importTree ./.;};
}
