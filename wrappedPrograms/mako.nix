{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.mako = (inputs.wrappers.wrapperModules.mako.apply {
      inherit pkgs;
      settings = {
        "background-color" = "#3c3836";
        "border-color" = "#e089a1";
        "border-radius" = 5;
        "border-size" = 2;
        "text-color" = "#bdae93";
        layer = "overlay";
        "default-timeout" = 5000;
      };
    }).wrapper;
  };
}
