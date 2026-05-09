{self, ...}: {
  flake.nixosModules.desktop = {
    config,
    pkgs,
    ...
  }: let
    selfpkgs = self.packages."${pkgs.system}";
    user = config.preferences.user.name;
  in {
    imports = [
      self.nixosModules.gtk
      self.nixosModules.audio
      self.nixosModules.bluetooth
      self.nixosModules.sddm
    ];

    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      fuzzel
      swww
      wl-clipboard
      libnotify
      brightnessctl
      pulsemixer
      fastfetch
      viewnior
      selfpkgs.alacritty
      selfpkgs.mako
    ];

    fonts.packages = with pkgs; [
      liberation_ttf
      noto-fonts-color-emoji
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.monaspace
      nerd-fonts.mononoki
    ];

    fonts.fontconfig.defaultFonts = {
      monospace = ["MonaspiceKr Nerd Font"];
    };

    time.timeZone = "Asia/Kolkata";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };

    services.upower.enable = true;
    security.polkit.enable = true;

    hardware = {
      uinput.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      config.common.default = "*";
    };

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
