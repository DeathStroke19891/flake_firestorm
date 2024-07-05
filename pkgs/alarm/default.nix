{pkgs}:
pkgs.writeShellScriptBin "alarm" ''
  set -e
  echo '${pkgs.mpv} ~/downloads/alarm.mp3' | ${pkgs.at} $@
''
