{inputs, ...}: {
  flake.nixosModules.power = {config, pkgs, ...}: {
    imports = [inputs.auto-cpufreq.nixosModules.default];

    users.users.${config.preferences.user.name}.extraGroups = [
      "power"
    ];

    services.auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };

    services.upower.enable = true;
    services.thermald.enable = true;
  };
}
