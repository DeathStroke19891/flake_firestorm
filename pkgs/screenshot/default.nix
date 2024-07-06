{pkgs}:
pkgs.writeShellScriptBin "screenshot" ''
  set -e
  export XDG_SCREENSHOTS_DIR="/home/parzival/pictures/screenshots/"
  a=$(echo -e "area\nactive\nscreen" | ${pkgs.rofi}/bin/rofi -dmenu -p "Select type of screenshot to be taken")
  if [[ $a == "" ]]; then
      exit
  else
      sleep 1
      ${pkgs.grimblast}/bin/grimblast copysave $a
  fi
''
