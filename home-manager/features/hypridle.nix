{
  pkgs,
  config,
  ...
}: {
  home.file = {
    ".config/hypr/hypridle.conf".text = ''
      general {
          lock_cmd = pidof hyprlock || hyprlock
          before_sleep_cmd = loginctl lock-session
          after_sleep_cmd = hyprctl dispatch dpms on
      }

      listener {
          timeout = 150
          on-timeout = light -O; light -S 5
          on-resume = light -I
      }

      listener {
          timeout = 300
          on-timeout = loginctl lock-session
      }

      listener {
          timeout = 380
          on-timeout = hyprctl dispatch dpms off
          on-resume = hyprctl dispatch dpms on
      }

      listener {
          timeout = 1800
          on-timeout = systemctl suspend
      }
    '';
  };
}
