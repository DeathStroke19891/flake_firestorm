{inputs, ...}: {
  flake.nixosModules.sddm = {pkgs, ...}: {
    imports = [
      inputs.silentSDDM.nixosModules.default
    ];

    programs.silentSDDM = {
      enable = true;
      theme = "rei";
      settings = {
        profileIcons = {
          parzival = pkgs.fetchurl {
            url = "https://i.ibb.co/3g59mN5/profile-picture.png";
            hash = "sha256-F/8aQT1aDXwtJ/Q9ddy7hYptjTQ+d7rgRUTqAhGegPQ=";
          };
        };
      };
    };
  };
}
