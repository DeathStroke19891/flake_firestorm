{
  inputs,
  self,
  ...
}: {
  flake.wrappersModules.alacritty = {config, ...}: {
    config.settings = {
      env.TERM = "xterm-256color";

      font = {
        size = 10.0;
        bold = {
          family = "MonaspiceKr Nerd Font";
          style = "Bold";
        };
        bold_italic = {
          family = "MonaspiceKr Nerd Font";
          style = "Bold Italic";
        };
        italic = {
          family = "MonaspiceKr Nerd Font";
          style = "Italic";
        };
        normal.family = "MonaspiceKr Nerd Font";
      };

      window = {
        opacity = 0.8;
        blur = true;
        padding = {
          x = 0;
          y = 0;
        };
      };
    };
  };

  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.alacritty = inputs.wrapper-modules.wrappers.alacritty.wrap {
      inherit pkgs;
      imports = [self.wrappersModules.alacritty];
      settings.terminal.shell.program = "${self'.packages.zsh}/bin/zsh";
    };
  };
}
