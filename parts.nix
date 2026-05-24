{inputs, ...}: let
  lib = inputs.nixpkgs.lib;
in {
  imports = [
    inputs.wrapper-modules.flakeModules.wrappers
    inputs.flake-parts.flakeModules.modules
  ];

  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      wrappersModules = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "BirdeeHub wrapper module definitions";
      };
      hardwareModules = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Hardware-specific NixOS modules";
      };
      theme = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Base16 theme palette with hash prefixes";
      };
      themeNoHash = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Base16 theme palette without hash prefixes";
      };
    };
  };

  config = {
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];

    perSystem = {pkgs, ...}: {
      formatter = pkgs.alejandra;
    };
  };
}
