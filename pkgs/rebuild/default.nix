{pkgs}:
pkgs.writeShellScriptBin "rebuild" ''
  set -e
  pushd ~/flake_firestorm/nixos/
  ${pkgs.nvchad}/bin/nvim configuration.nix
  ${pkgs.alejandra}/bin/alejandra . &>/dev/null
  ${pkgs.git}/bin/git diff -U0 *.nix
  popd
  pushd ~/flake_firestorm
  echo "NixOS Rebuilding..."
  sudo nixos-rebuild switch --flake .#Firestorm &>~/flake_firestorm/nixos-switch.log || ( cat nixos-switch.log | grep --color error && false)
  gen_info=$(nixos-rebuild --flake .#Firestorm list-generations | awk '/True$/ {printf "Gen %s - %s - %s - %s", $1, $2 " " $3, $4, $5}')
  ${pkgs.git}/bin/git commit -am "Update system: $gen_info"
''
