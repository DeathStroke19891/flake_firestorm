# Defines preferences.autostart: programs spawned at compositor startup.
# Consumed by nixos/features/niri.nix to emit spawn-at-startup KDL blocks.
{
  flake.nixosModules.base = {lib, ...}: {
    options.preferences.autostart = lib.mkOption {
      type = lib.types.listOf (lib.types.either lib.types.str lib.types.package);
      default = [];
      description = "Programs to spawn at compositor startup (strings or packages).";
    };
  };
}
