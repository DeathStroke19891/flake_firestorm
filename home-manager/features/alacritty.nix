{
  pkgs,
  config,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };

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

        normal = {
          family = "MonaspiceKr Nerd Font";
        };
      };

      window = {
        opacity = 0.4;

        padding = {
          x = 0;
          y = 0;
        };

        blur = true;
      };

      # colors = with config.colorScheme.palette; {
      #   primary = {
      #     background = "0x${base00}";
      #     foreground = "0x${base05}";
      #     dim_foreground = "#7f849c";
      #     bright_foreground = "0x${base05}";
      #   };

      #   cursor = {
      #     text = "0x${base00}";
      #     cursor = "0x${base06}";
      #   };

      #   search.matches = {
      #     foreground = "0x${base00}";
      #     background = "0x${base0B}";
      #   };

      #   search.focused_match = {
      #     foreground = "0x${base00}";
      #     background = "0x${base0A}";
      #   };

      #   footer_bar = {
      #     foreground = "0x${base00}";
      #     background = "0x${base0B}";
      #   };

      #   hints.start = {
      #     foreground = "0x${base00}";
      #     background = "0x${base0A}";
      #   };

      #   hints.end = {
      #     foreground = "0x${base00}";
      #     background = "0x${base0A}";
      #   };

      #   selection = {
      #     text = "0x${base00}";
      #     background = "0x${base06}";
      #   };

      #   normal = {
      #     black = "0x${base03}";
      #     magenta = "#f5c2e7";
      #     green = "0x${base0B}";
      #     yellow = "0x${base0A}";
      #     blue = "0x${base0D}";
      #     red = "0x${base08}";
      #     cyan = "0x${base0C}";
      #     white = "#bac2de";
      #   };

      #   bright = {
      #     black = "0x${base04}";
      #     magenta = "#f5c2e7";
      #     green = "0x${base0B}";
      #     yellow = "0x${base0A}";
      #     blue = "0x${base0D}";
      #     red = "0x${base08}";
      #     cyan = "0x${base0C}";
      #     white = "#a6adc8";
      #   };

      #   dim = {
      #     black = "0x${base03}";
      #     magenta = "#f5c2e7";
      #     green = "0x${base0B}";
      #     yellow = "0x${base0A}";
      #     blue = "0x${base0D}";
      #     red = "0x${base08}";
      #     cyan = "0x${base0C}";
      #     white = "#bac2de";
      #   };
      # };
    };
  };
}
