{pkgs}:
pkgs.writeShellScriptBin "rebuild" ''
  set -e
  pushd ~/flake_firestorm/nixos/
  ${pkgs.emacs}/bin/emacsclient -c -a 'emacs' configuration.nix
  ${pkgs.alejandra}/bin/alejandra . &>/dev/null
  ${pkgs.git}/bin/git diff -U0 *.nix
  echo "NixOS Rebuilding..."
  ${pkgs.sudo}/bin/sudo nixos-rebuild switch &>nixos-switch.log || ( cat nixos-switch.log | grep --color error && false)
  gen=$(nixos-rebuild list-generations | grep current)
  ${pkgs.git}/bin/git commit -am "$gen"
''
