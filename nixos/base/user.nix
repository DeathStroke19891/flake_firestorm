# Defines the preferences.user option consumed by all host and hjem modules.
# Each host sets preferences.user.name in its configuration.nix.
{
  flake.nixosModules.base = {lib, ...}: {
    options.preferences = {
      user.name = lib.mkOption {
        type = lib.types.str;
        default = "parzival";
        description = "Primary user name for this host.";
      };
    };
  };
}
