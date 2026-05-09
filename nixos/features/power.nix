{inputs, ...}: {
  flake.nixosModules.power = {pkgs, ...}: {
    imports = [inputs.auto-cpufreq.nixosModules.default];

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

    environment.systemPackages = [pkgs.powertop];
  };
}
