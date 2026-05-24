{inputs, ...}: {
  flake.nixosModules.input = {config, ...}: {
    imports = [inputs.xremap-flake.nixosModules.default];

    services.xremap = {
      enable = true;
      withNiri = true;
      userName = config.preferences.user.name;
      config = {
        modmap = [
          {
            name = "main remaps";
            remap = {
              "rightalt" = "leftmeta";
              CapsLock = {
                held = "leftctrl";
                alone = "esc";
                alone_timeout_millis = 150;
              };
            };
            device = {
              only = [
                "AT Translated Set 2 keyboard"
                "Logitech K850"
                "Varmilo VD-1 Keyboard"
              ];
            };
          }
        ];
      };
    };
  };
}
