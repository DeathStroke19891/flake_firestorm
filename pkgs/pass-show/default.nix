{pkgs}:
pkgs.writeShellScriptBin "pass-show" ''
  set -e

  a=$(echo -e "Copy password\nGenerate password\nInsert password" | ${pkgs.rofi}/bin/rofi -dmenu -p "Select operation to be performed to be performed")
  if [[ $a == "" ]]; then
      exit
  elif [[ $a == "Copy password" ]]; then
      b=$(${pkgs.findutils}/bin/find $HOME/.password-store -iname "*.gpg" | ${pkgs.hck}/bin/hck -Ld'/' -I -f5- | ${pkgs.hck}/bin/hck -Ld'.' -f1 | ${pkgs.rofi}/bin/rofi -dmenu -p "Select the password to be copied")
      if [[ $b == "" ]]; then
          exit
      fi
      ${pkgs.pass-wayland}/bin/pass show -c $b
      sleep 1
      notify-send -t 6000 "The password at $b has been copied to your clipboard"
  elif [[ $a == "Generate password" ]]; then
      b=$(${pkgs.rofi}/bin/rofi -dmenu -p "Select the directory where the password has to be stored")
      if [[ $b == "" ]]; then
          exit
      fi
      ${pkgs.pass-wayland}/bin/pass generate $b
      sleep 1
      ${pkgs.pass-wayland}/bin/pass show -c $b
      sleep 1
      notify-send -t 6000 "A password has been generated at $b and has been copied to your clipboard"
  else
      b=$(${pkgs.rofi}/bin/rofi -dmenu -p "Select the directory where the password has to be inserted")
      if [[ $b == "" ]]; then
          exit
      fi
      ${pkgs.pass-wayland}/bin/pass insert $b
      sleep 1
      notify-send -t 6000 "A password has been inserted at $b"
  fi
''
