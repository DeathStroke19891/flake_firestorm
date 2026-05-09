# Niri compositor: system enable + user KDL config via hjem.
# Keybinds use Mod (Super). Adjust spawn commands to taste.
{...}: {
  flake.nixosModules.niri = {
    config,
    pkgs,
    ...
  }: let
    user = config.preferences.user.name;
  in {
    programs.niri.enable = true;

    # XDG desktop portal — provides screenshare, file-picker, etc.
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      config.common.default = "*";
    };

    security.polkit.enable = true;
    # Allow swaylock to authenticate via PAM
    security.pam.services.swaylock = {};

    hjem.users.${user}.xdg.config.files."niri/config.kdl".text = ''
      input {
          keyboard {
              xkb {
                  layout "us"
              }
          }
          touchpad {
              tap
              natural-scroll
          }
      }

      layout {
          gaps 8
          default-column-width { proportion 0.5; }
          focus-ring {
              width 4
              active-color "#7daea3"
              inactive-color "#504945"
          }
      }

      prefer-no-csd

      spawn-at-startup "swww-daemon"
      spawn-at-startup "mako"

      binds {
          Mod+Return { spawn "alacritty"; }
          Mod+Space { spawn "fuzzel"; }
          Mod+Q { close-window; }
          Mod+Shift+Q { quit; }

          Mod+Left  { focus-column-left; }
          Mod+Right { focus-column-right; }
          Mod+Up    { focus-window-up; }
          Mod+Down  { focus-window-down; }

          Mod+Shift+Left  { move-column-left; }
          Mod+Shift+Right { move-column-right; }
          Mod+Shift+Up    { move-window-up; }
          Mod+Shift+Down  { move-window-down; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }

          Mod+Shift+1 { move-window-to-workspace 1; }
          Mod+Shift+2 { move-window-to-workspace 2; }
          Mod+Shift+3 { move-window-to-workspace 3; }
          Mod+Shift+4 { move-window-to-workspace 4; }
          Mod+Shift+5 { move-window-to-workspace 5; }

          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }

          Print { screenshot; }
          Ctrl+Print { screenshot-screen; }
          Alt+Print { screenshot-window; }

          XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
          XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
          XF86AudioMute        { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }

          XF86MonBrightnessUp   { spawn "brightnessctl" "set" "10%+"; }
          XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }
      }
    '';
  };
}
