# Git: full config + delta pager via GIT_CONFIG_GLOBAL env var.
# Uses wrappers.lib.wrapPackage (no pre-built git wrapper module needed).
# Delta is referenced by absolute store path — not added to user PATH.
{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    deltaConfig = pkgs.writeText "delta.gitconfig" ''
      [core]
        pager = ${pkgs.delta}/bin/delta

      [interactive]
        diffFilter = ${pkgs.delta}/bin/delta --color-only

      [delta]
        navigate = true
        dark = true
    '';

    gitConfig = pkgs.writeText "gitconfig" ''
      [user]
        name = Sridhar D Kedlaya
        email = sridhardked@gmail.com

      [core]
        compression = 9
        whitespace = error
        preloadindex = true

      [advice]
        addEmptyPathspec = false
        pushNonFastForward = false
        statusHints = false

      [url "git@github.com:DeathStroke19891/"]
        insteadOf = ds:

      [url "git@github.com:"]
        insteadOf = gh:

      [init]
        defaultBranch = dev

      [status]
        branch = true
        showStash = true
        showUntrackedFiles = all

      [merge]
        conflictstyle = zdiff3

      [interactive]
        singlekey = true

      [diff]
        context = 3
        renames = copies
        interHunkContext = 10

      [commit]
        verbose = true

      [push]
        autoSetupRemote = true
        default = current
        followTags = true

      [pull]
        rebase = true

      [rebase]
        autoStash = true
        missingCommitsCheck = warn

      [log]
        abbrevCommit = true
        graphColors = blue,yellow,cyan,magenta,green,red

      [color "decorate"]
        HEAD = red
        branch = blue
        tag = yellow
        remoteBranch = magenta

      [color "branch"]
        current = magenta
        local = default
        remote = yellow
        upstream = green
        plain = blue

      [branch]
        sort = -committerdate

      [tag]
        sort = -taggerdate

      [pager]
        branch = false
        tag = false

      [include]
        path = ${deltaConfig}
    '';
  in {
    packages.git = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.git;
      # GIT_CONFIG_GLOBAL points git at our store-path config.
      # `git config --global` writes will fail (read-only store) — acceptable.
      env.GIT_CONFIG_GLOBAL = gitConfig;
    };
  };
}
