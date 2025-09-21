{ pkgs }:

pkgs.writeShellScriptBin "track" ''
  set -e

  CATEGORIES=( "MATH" "PROGRAMMING" "WASTED" "CTF" "PARIAH" "WORK" "STOP" )

  ORIG_STATUS=$(${pkgs.tmux}/bin/tmux show -gv "@orig_status_right")
  if [ -z "$ORIG_STATUS" ]; then
    ${pkgs.tmux}/bin/tmux set-option -gq @orig_status_right "$(${pkgs.tmux}/bin/tmux show -gv status-right)"
    ORIG_STATUS=$(${pkgs.tmux}/bin/tmux show -gv "@orig_status_right")
  fi

  selected=$(printf "%s\n" "''${CATEGORIES[@]}" | ${pkgs.fzf}/bin/fzf --prompt="Select category: ")

  if [[ -z "$selected" ]]; then
    echo "No category selected, exiting."
    exit 1
  fi

  if [[ "$selected" == "STOP" ]]; then
    ${pkgs.timewarrior}/bin/timew stop
    ${pkgs.tmux}/bin/tmux set -g status-right "$ORIG_STATUS"
  else
    ${pkgs.timewarrior}/bin/timew stop
    ${pkgs.timewarrior}/bin/timew start "$selected"
    cleaned_status=$(${pkgs.tmux}/bin/tmux show -gv status-right | sed 's/ *#\[category\][^#]*#\[default\]//')
    ${pkgs.tmux}/bin/tmux set -g status-right "$cleaned_status #[fg=black,bg=brightgreen,bold] #[category]$selected #[default]"
  fi
''
