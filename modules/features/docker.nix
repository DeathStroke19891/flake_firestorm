{...}: {
  flake.nixosModules.docker = {...}: {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    virtualisation.podman.enable = true;
  };
}
