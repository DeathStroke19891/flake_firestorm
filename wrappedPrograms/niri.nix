{
  inputs,
  self,
  ...
}: {
  flake.wrappersModules.niri = {config, ...}: {
    config.settings = {
      prefer-no-csd = null;

      input = {
        keyboard.xkb = {
          layout = "us";
        };
        touchpad = {
          tap = null;
          natural-scroll = null;
        };
      };

      layout = {
        gaps = 8;
        default-column-width.proportion = 0.5;
        focus-ring = {
          width = 4;
          active-color = "#7daea3";
          inactive-color = "#504945";
        };
      };

      spawn-at-startup = [
        "${config.pkgs.swww}/bin/swww-daemon"
      ];

      binds = {
        "Mod+Return".spawn = "alacritty";
        "Mod+Space".spawn = "fuzzel";
        "Mod+Q".close-window = null;
        "Mod+Shift+Q".quit = null;

        "Mod+Left".focus-column-left = null;
        "Mod+Right".focus-column-right = null;
        "Mod+Up".focus-window-up = null;
        "Mod+Down".focus-window-down = null;

        "Mod+Shift+Left".move-column-left = null;
        "Mod+Shift+Right".move-column-right = null;
        "Mod+Shift+Up".move-window-up = null;
        "Mod+Shift+Down".move-window-down = null;

        "Mod+1".focus-workspace = 1;
        "Mod+2".focus-workspace = 2;
        "Mod+3".focus-workspace = 3;
        "Mod+4".focus-workspace = 4;
        "Mod+5".focus-workspace = 5;

        "Mod+Shift+1".move-window-to-workspace = 1;
        "Mod+Shift+2".move-window-to-workspace = 2;
        "Mod+Shift+3".move-window-to-workspace = 3;
        "Mod+Shift+4".move-window-to-workspace = 4;
        "Mod+Shift+5".move-window-to-workspace = 5;

        "Mod+F".maximize-column = null;
        "Mod+Shift+F".fullscreen-window = null;

        "Print".screenshot = null;
        "Ctrl+Print".screenshot-screen = null;
        "Alt+Print".screenshot-window = null;

        "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
        "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
        "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

        "XF86MonBrightnessUp".spawn-sh = "brightnessctl set 10%+";
        "XF86MonBrightnessDown".spawn-sh = "brightnessctl set 10%-";
      };
    };
  };

  perSystem = {pkgs, ...}: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      imports = [self.wrappersModules.niri];
    };
  };
}
