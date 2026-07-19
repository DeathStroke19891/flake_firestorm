{
  inputs,
  self,
  ...
}: {
  flake.wrappersModules.git = {config, ...}: let
    deltaConfig = config.pkgs.writeText "delta.gitconfig" ''
      [core]
        pager = ${config.pkgs.delta}/bin/delta

      [interactive]
        diffFilter = ${config.pkgs.delta}/bin/delta --color-only

      [delta]
        navigate = true
        dark = true
    '';
  in {
    config.settings = {
      user = {
        name = "Sridhar D Kedlaya";
        email = "sridhardked@gmail.com";
      };

      core = {
        compression = 9;
        whitespace = "error";
        preloadindex = true;
      };

      advice = {
        addEmptyPathspec = false;
        pushNonFastForward = false;
        statusHints = false;
      };

      url = {
        "git@github.com:DeathStroke19891/".insteadOf = "ds:";
        "git@github.com:".insteadOf = "gh:";
      };

      init.defaultBranch = "dev";

      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = "all";
      };

      merge.conflictstyle = "zdiff3";
      interactive.singlekey = true;

      diff = {
        context = 3;
        renames = "copies";
        interHunkContext = 10;
      };

      commit.verbose = true;

      push = {
        autoSetupRemote = true;
        default = "current";
        followTags = true;
      };

      pull.rebase = true;

      rebase = {
        autoStash = true;
        missingCommitsCheck = "warn";
      };

      log = {
        abbrevCommit = true;
        graphColors = "blue,yellow,cyan,magenta,green,red";
      };

      "color \"decorate\"" = {
        HEAD = "red";
        branch = "blue";
        tag = "yellow";
        remoteBranch = "magenta";
      };

      "color \"branch\"" = {
        current = "magenta";
        local = "default";
        remote = "yellow";
        upstream = "green";
        plain = "blue";
      };

      branch.sort = "-committerdate";
      tag.sort = "-taggerdate";

      pager = {
        branch = false;
        tag = false;
      };

      include.path = "${deltaConfig}";
    };
  };

  perSystem = {pkgs, ...}: {
    packages.git = inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;
      imports = [self.wrappersModules.git];
    };
  };
}
