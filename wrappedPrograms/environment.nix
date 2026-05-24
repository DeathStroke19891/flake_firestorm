{
  inputs,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    lib,
    ...
  }: {
    packages.environment = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.zsh;
      runtimeInputs = [
        self'.packages.cli-tools
        self'.packages.dev-tools
        self'.packages.git
      ];
    };
  };
}
