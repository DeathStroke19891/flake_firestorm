# Alacritty: font + window settings via flake.wrappersModules;
# perSystem builds the derivation via Lassulus wrapperModules.alacritty,
# injecting the wrapped zsh as the default shell.
{
  inputs,
  self,
  ...
}: {
  # Shared configuration module: fonts, window opacity/blur, padding.
  # Kept in wrappersModules so self/theme can be referenced if needed later.
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
        opacity = 0.4;
        blur = true;
        padding = {
          x = 0;
          y = 0;
        };
      };
    };
  };

  # Build the wrapped alacritty derivation.
  # settings.terminal.shell.program is set here (needs self'.packages.zsh from perSystem).
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.alacritty = (inputs.wrappers.wrapperModules.alacritty.apply {
      inherit pkgs;
      imports = [self.wrappersModules.alacritty];
      settings.terminal.shell.program = "${self'.packages.zsh}/bin/zsh";
    }).wrapper;
  };
}
