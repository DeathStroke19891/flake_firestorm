{
  pkgs,
  config,
  inputs,
  ...
}: let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    #${pkgs.emacs} --init-directory $HOME/.config/emacs --daemon
    ${pkgs.swww}/bin/swww init &

    ${pkgs.mako}/bin/mako &

    ${pkgs.udiskie}/bin/udiskie &

    ${pkgs.wl-clipboard}/wl-paste --type text --watch cliphist store &
    ${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store &

    ${pkgs.hypridle}/bin/hypridle &
    ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd HYPRLAND_INSTANCE_SIGNATURE
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;

    plugins = [
      inputs.hyprfocus.packages."${pkgs.system}".default
    ];

    settings = {
      monitor = ",1920x1080@60, auto, 1";

      env = [
        "MOZ_ENABLE_WAYLAND = 1"
        "HYPRCURSOR_THEME, phinger-cursors-dark"
        "HYPRCURSOR_SIZE, 24"
        "XCURSOR_THEME, phinger-cursors-dark"
        "XCURSOR_SIZE, 24"
      ];

      exec-once = [
        ''${startupScript}/bin/start''
        "eww daemon"
        "eww open bar"
        "[workspace special:spot silent] spotify"
        "[workspace special:term silent] alacritty"
        "[workspace special:mail silent] thunderbird"
        "[workspace special:whats silent] firefox"
        "[workspace special:doom silent] alacritty -e nvim"
        "[workspace special:calc silent] alacritty -e qalc"
        "[workspace special:torrent silent] transmission-qt"
      ];

      exec = "hyprshade auto";

      input = {
        kb_layout = "us, us";
        kb_variant = "dvp,";
        kb_options = "grp:rctrl_rshift_toggle";
        numlock_by_default = true;
        follow_mouse = 1;
        accel_profile = "adaptive";

        touchpad = {
          natural_scroll = "no";
        };

        sensitivity = 0;
      };

      cursor = {
        inactive_timeout = 0; # 0 = forever
        no_warps = true;
        enable_hyprcursor = true;
        hide_on_key_press = false;
        hide_on_touch = false;
      };

      general = with config.colorScheme.palette; {
        gaps_in = 5;
        gaps_out = 15;
        border_size = 5;
        "col.active_border" = "rgba(${base0E}ff) rgba(${base09}ff) 60deg";
        "col.inactive_border" = "rgba(${base00}ff)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 15;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        blur = {
          enabled = true;
          size = 3;
          passes = 5;
          new_optimizations = true;
          xray = false;
          ignore_opacity = true;
        };
        drop_shadow = true;
        shadow_ignore_window = true;
        shadow_offset = "1 2";
        shadow_range = 10;
        shadow_render_power = 5;
        "col.shadow" = "0x66000000";
        blurls = [
          "gtk-layer-shell"
          "lockscreen"
        ];
      };

      animations = {
        enabled = "yes";
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      "plugin:hyprfocus" = {
        enabled = "yes";
        animate_floating = "yes";
        animate_workspacechange = "no";
        focus_animation = "shrink";
        bezier = [
          "bezIn, 0.5,0.0,1.0,0.5"
          "bezOut, 0.0,0.5,0.5,1.0"
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
          "realsmooth, 0.28,0.29,.69,1.08"
        ];
        flash = {
          flash_opacity = 0.85;
          in_bezier = "realsmooth";
          in_speed = 0.5;
          out_bezier = "realsmooth";
          out_speed = 3;
        };
        shrink = {
          shrink_percentage = 0.90;
          in_bezier = "realsmooth";
          in_speed = 1;
          out_bezier = "realsmooth";
          out_speed = 2;
        };
      };

      dwindle = {
        no_gaps_when_only = false;
        pseudotile = true;
        preserve_split = true;
        force_split = 3;
      };

      master = {
        new_status = "master";
        new_on_top = true;
        no_gaps_when_only = false;
        always_center_master = false;
        mfact = 0.50;
      };

      gestures = {
        workspace_swipe = "on";
        workspace_swipe_forever = true;
      };

      misc = {
        enable_swallow = true;
        new_window_takes_over_fullscreen = 2;
      };

      "$mainMod" = "ALT";

      bind = [
        "$mainMod, RETURN, exec, alacritty"
        "$mainMod, E, exec, alacritty -e yazi"
        "$mainMod, F, exec, floorp"
        "$mainMod SHIFT, F, exec, floorp -P College"
        "$mainMod, D, exec, alacritty -e nvim"
        "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        "$mainMod, R, exec, rofi -show drun"
        "$mainMod, S, exec, sioyek"
        "$mainMod, Z, exec, zathura"
        "$mainMod SHIFT, P, exec, pass-show"
        "$mainMod SHIFT, U, focusmonitor, HDMI-A-1"

        ", XF86MonBrightnessUp, exec,light -A 5"
        ", XF86MonBrightnessDown, exec, light -U 5"
        ", XF86AudioRaiseVolume, exec, pulsemixer --change-volume +5"
        ", XF86AudioLowerVolume, exec, pulsemixer --change-volume -5"
        ", XF86AudioMute, exec, pulsemixer --toggle-mute"
        ", Print, exec, screenshot"
        ", XF86AudioPlay, exec, kooha"
        ", XF86AudioNext, exec, $HOME/shell-scripts/change-wallpaper.sh"
        ", XF86AudioPrev, exec, hyprshade toggle"
        ", XF86Presentation,exec, $HOME/shell-scripts/change-wallpaper.sh"

        "$mainMod_SHIFT, C, killactive"
        "$mainMod_CTRL, Z, movewindow, \"HDMI-A-1\""

        "$mainMod_SHIFT, T, togglefloating,"

        "$mainMod, Q, exec, systemctl suspend"
        "$mainMod_SHIFT, Q, exit,"
        "$mainMod CTRL, Q, exec, hyprlock"

        "$mainMod_CTRL, Return, togglespecialworkspace, term"
        "$mainMod_CTRL, D, togglespecialworkspace, doom"
        "$mainMod_CTRL, T, togglespecialworkspace, mail"
        "$mainMod_CTRL, W, togglespecialworkspace, whats"
        "$mainMod_CTRL, C, togglespecialworkspace, calc"
        "$mainMod_CTRL, S, togglespecialworkspace, spot"
        "$mainMod_CTRL, O, togglespecialworkspace, torrent"
        "$mainMod_CTRL, R, togglespecialworkspace, random"
        "$mainMod_CTRL, P, togglespecialworkspace, io.github.alainm23.planify"

        "$mainMod, M, fullscreen, 1"
        "$mainMod_SHIFT, M, fullscreen"
        "$mainMod_SHIFT_CTRL, M, fullscreenstate, 0 3"

        "$mainMod_CTRL, H, resizeactive, -20 0"
        "$mainMod_CTRL, L, resizeactive, 20 0"
        "$mainMod_CTRL, J, resizeactive, 0 -20"
        "$mainMod_CTRL, K, resizeactive, 0 20"
        "$mainMod, Tab, cyclenext"
        "$mainMod_SHIFT, Tab, cyclenext, prev"

        "$mainMod_SHIFT, K, layoutmsg, swapnext"
        "$mainMod_SHIFT, J, layoutmsg, swapprev"
        "$mainMod_SHIFT, H, layoutmsg, swapwithmaster"
        "$mainMod_SHIFT, L, layoutmsg, swapwithmaster"
        "$mainMod, SPACE, layoutmsg, orientationnext"
        "$mainMod_SHIFT, SPACE, layoutmsg, orientationprev"

        "$mainMod, P, pseudo,"
        "$mainMod, T, togglesplit,"

        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, cyclenext"
        "$mainMod, J, cyclenext, prev"

        "$mainMod, parenleft, workspace, 1"
        "$mainMod, parenright, workspace, 2"
        "$mainMod, braceright, workspace, 3"
        "$mainMod, plus, workspace, 4"
        "$mainMod, braceleft, workspace, 5"
        "$mainMod, bracketright, workspace, 6"
        "$mainMod, bracketleft, workspace, 7"
        "$mainMod, exclam, workspace, 8"

        "$mainMod SHIFT, parenleft, movetoworkspacesilent, 1"
        "$mainMod SHIFT, parenright, movetoworkspacesilent, 2"
        "$mainMod SHIFT, braceright, movetoworkspacesilent, 3"
        "$mainMod SHIFT, plus, movetoworkspacesilent, 4"
        "$mainMod SHIFT, braceleft, movetoworkspacesilent, 5"
        "$mainMod SHIFT, bracketright, movetoworkspacesilent, 6"
        "$mainMod SHIFT, bracketleft, movetoworkspacesilent, 7"
        "$mainMod SHIFT, R, movetoworkspacesilent, special:random"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        "$mainMod_SUPER, T, togglegroup"
        "$mainMod_SUPER, H, movewindoworgroup, l"
        "$mainMod_SUPER, L, movewindoworgroup, r"
        "$mainMod_SUPER, J, movewindoworgroup, d"
        "$mainMod_SUPER, K, movewindoworgroup, u"
        "$mainMod_SUPER, Tab, changegroupactive, f"
        "$mainMod_SUPER_SHIFT, Tab, changegroupactive, b"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindl = ",switch:on:Lid Switch, exec, hyprlock";
    };
  };
}
