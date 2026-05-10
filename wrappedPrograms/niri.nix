{
  inputs,
  self,
  ...
}: {
  flake.wrappersModules.niri = {config, lib, pkgs, ...}: {
    config.settings = let 
      noctaliaExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.noctalia-shell;
    in {
      prefer-no-csd = _: {};

      input = {
        keyboard.xkb = {
          layout = "us";
        };
        touchpad = {
          tap = _: {};
          natural-scroll = _: {};
        };
        mouse = {
          accel-profile = "adaptive";
        };
      };

      layout = {
        gaps = 25;
        default-column-width.proportion = 0.5;
        focus-ring = {
          width = 4;
          active-color = "#7daea3";
          inactive-color = "#504945";
        };
      };

      spawn-at-startup = [
        noctaliaExe
      ];

      binds = {
        "Mod+Return".spawn-sh = lib.getExe pkgs.alacritty;

        "Mod+Q".close-window = _: {};
        "Mod+F".maximize-column = _: {};
        "Mod+G".fullscreen-window = _: {};
        "Mod+Shift+F".toggle-window-floating = _: {};
        "Mod+C".center-column = _: {};
        "Mod+Shift+Q".quit = _: {};
        
        "Mod+H".focus-column-left = _: {};
        "Mod+L".focus-column-right = _: {};
        "Mod+K".focus-window-up = _: {};
        "Mod+J".focus-window-down = _: {};

        "Mod+Left".focus-column-left = _: {};
        "Mod+Right".focus-column-right = _: {};
        "Mod+Up".focus-window-up = _: {};
        "Mod+Down".focus-window-down = _: {};

        "Mod+Shift+Left".move-column-left = _: {};
        "Mod+Shift+Right".move-column-right = _: {};
        "Mod+Shift+Up".move-window-up = _: {};
        "Mod+Shift+Down".move-window-down = _: {};

        "Mod+Ctrl+H".set-column-width = "-5%";
        "Mod+Ctrl+L".set-column-width = "+5%";
        "Mod+Ctrl+J".set-window-height = "-5%";
        "Mod+Ctrl+K".set-window-height = "+5%";

        "Mod+WheelScrollDown".focus-column-left = _: {};
        "Mod+WheelScrollUp".focus-column-right = _: {};
        "Mod+Ctrl+WheelScrollDown".focus-workspace-down = _: {};
        "Mod+Ctrl+WheelScrollUp".focus-workspace-up = _: {};

        "Mod+1".focus-workspace = 1;
        "Mod+2".focus-workspace = 2;
        "Mod+3".focus-workspace = 3;
        "Mod+4".focus-workspace = 4;
        "Mod+5".focus-workspace = 5;
        "Mod+6".focus-workspace = 6;
        "Mod+7".focus-workspace = 7;
        "Mod+8".focus-workspace = 8;
        "Mod+9".focus-workspace = 9;

        "Mod+Shift+1".move-window-to-workspace = 1;
        "Mod+Shift+2".move-window-to-workspace = 2;
        "Mod+Shift+3".move-window-to-workspace = 3;
        "Mod+Shift+4".move-window-to-workspace = 4;
        "Mod+Shift+5".move-window-to-workspace = 5;
        "Mod+Shift+6".move-window-to-workspace = 6;
        "Mod+Shift+7".move-window-to-workspace = 7;
        "Mod+Shift+8".move-window-to-workspace = 8;
        "Mod+Shift+9".move-window-to-workspace = 9;

        "Mod+Space".spawn-sh = "${noctaliaExe} ipc call launcher toggle"; 
        "Mod+S".spawn-sh = "${noctaliaExe} ipc call controlCenter toggle"; 
        "Mod+Comma".spawn-sh = "${noctaliaExe} ipc call settings toggle";

        "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
        "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
        "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

        "Print".screenshot = _: {};
        "Ctrl+Print".screenshot-screen = _: {};
        "Alt+Print".screenshot-window = _: {};


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
