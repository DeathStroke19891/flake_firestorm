{pkgs}:
pkgs.writeShellScriptBin "home-rebuild" ''
  set -e
  pushd ~/.config/home-manager/
  ${pkgs.emacs}/bin/emacsclient -c -a 'emacs' home.nix
  ${pkgs.alejandra}/bin/alejandra . &>/dev/null
  ${pkgs.git}/bin/git diff -U0 *.nix
  echo "home-manager Rebuilding..."
  ${pkgs.home-manager}/bin/home-manager switch &>~/.config/home-manager/home-switch.log || ( cat home-switch.log | grep --color error && false)
  gen=$(home-manager generations | head -n 1)
  ${pkgs.git}/bin/git commit -am "$gen"
''
