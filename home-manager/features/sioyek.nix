{pkgs, ...}: {
  home.packages = [pkgs.sioyek];

  xdg.configFile."sioyek/prefs_user.config".text = ''
    # side of pages
    background_color  0.188 0.196 0.212
    dark_mode_background_color 0.074 0.082 0.0941

    custom_background_color 0.074 0.082 0.0941
    custom_text_color 0.871 0.890 0.910

    text_highlight_color 0.529 0.686 0.875
    synctex_highlight_color 0.686 0.875 0.529
    link_highlight_color 0.561 0.323 0.788

    vertical_line_color 0.0 0.0 0.0 0.0
    should_use_multiple_monitors 1

    font_size 16
    ui_font Clear Sans

    status_bar_color  0.188 0.196 0.212
    status_bar_text_color 0.757 0.766 0.792
    status_bar_font_size 10

    startup_commands toggle_custom_color
  '';

  xdg.configFile."sioyek/keys_user.config".text = ''
    move_down j
    move_up k
    move_left l
    move_right h

    add_highlight ,

    goto_begining <home>

    toggle_dark_mode c
    toggle_custom_color n

    quit q
    quit <C-q>

    pop_state y
    fit_to_page_width_smart w

    zoom_in +
    zoom_in <C-+>

    zoom_out -
    zoom_out <C-->

    next_state <A-<right>>
    prev_state <A-<left>>

    next_item <C-g>

    set_mark <C-m>
    goto_mark <C-j>

    toggle_synctex <f8>
  '';
}
