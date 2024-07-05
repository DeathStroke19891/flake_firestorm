{
  pkgs,
  config,
  ...
}: {
  systemd.user.services.hyprshade = {
    Unit = {
      Description = "Apply screen filter";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.hyprshade}/bin/hyprshade auto";
    };
  };

  systemd.user.timers.hyprshade = {
    Unit = {
      Description = "Apply screen filter on schedule";
    };
    Timer = {
      OnCalendar = [
        "*-*-* 06:00:00"
        "*-*-* 19:00:00"
      ];
    };
    Install = {
      WantedBy = ["timers.target"];
    };
  };

  home.file = {
    ".config/hypr/hyprshade.toml".text = ''
      [[shades]]
      name = "vibrance"
      default = true

      [[shades]]
      name = "blue-light-filter"
      start_time = 19:00:00
      end_time = 06:00:00
    '';
  };
}
