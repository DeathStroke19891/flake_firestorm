# Framework-level hjem setup: imports the hjem NixOS module and configures
# the primary user's home directory. All feature modules that write dotfiles
# via hjem.users.* depend on this being imported first.
{inputs, ...}: {
  flake.nixosModules.extra_hjem = {config, ...}: let
    user = config.preferences.user.name;
  in {
    imports = [
      inputs.hjem.nixosModules.default
    ];

    config = {
      hjem = {
        users."${user}" = {
          enable = true;
          directory = "/home/${user}";
          user = "${user}";
        };

        clobberByDefault = true;
      };
    };
  };
}
