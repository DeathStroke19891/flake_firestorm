# Defines preferences.monitors: declarative output (monitor) configuration.
# Consumed by nixos/features/niri.nix to emit output {} KDL blocks.
# Keys are niri output names (e.g. "eDP-1", "HDMI-A-1").
# Leave empty (default) to let niri auto-detect all connected outputs.
{
  flake.nixosModules.base = {lib, ...}: {
    options.preferences.monitors = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          primary = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          width = lib.mkOption {
            type = lib.types.int;
            example = 1920;
          };
          height = lib.mkOption {
            type = lib.types.int;
            example = 1080;
          };
          refreshRate = lib.mkOption {
            type = lib.types.float;
            default = 60.0;
          };
          x = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };
          y = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };
          enabled = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
        };
      });
      default = {};
      description = ''
        Monitor configuration keyed by niri output name (e.g. eDP-1, HDMI-A-1).
        Run `niri msg outputs` to discover output names on a live system.
      '';
    };
  };
}
