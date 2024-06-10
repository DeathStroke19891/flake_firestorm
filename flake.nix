{
  description = "NixOS flake for Firestorm";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs/nixos-23.11";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    nix-alien.url = "github:thiagokokada/nix-alien";
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, auto-cpufreq, stylix, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
      {
        nixosConfigurations = {
          Firestorm = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system; };

            modules = [
              ./nixos/configuration.nix
              auto-cpufreq.nixosModules.default
              stylix.nixosModules.stylix
            ];
          };
        };
      };
}
