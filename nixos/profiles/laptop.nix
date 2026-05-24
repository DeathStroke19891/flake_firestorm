{self, ...}: {
  flake.nixosModules.profile-laptop = {...}: {
    imports = [
      self.nixosModules.power
      self.nixosModules.input
    ];
  };
}
