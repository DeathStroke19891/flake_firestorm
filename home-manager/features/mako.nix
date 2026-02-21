{
  pkgs,
  config,
  ...
}: {
  services.mako = {
    enable = true;

    settings = {
      background-color = "#${config.colorScheme.palette.base01}";
      border-color = "#${config.colorScheme.palette.base0E}";
      border-radius = 5;
      border-size = 2;
      text-color = "#${config.colorScheme.palette.base04}";
      layer = "overlay";
      default-timeout = 5000;
    };
  };
}
