{
  flake.nixosModules.app-creative = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      blender
      godot
      processing
    ];
  };
}
