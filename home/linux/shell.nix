{
  config,
  myvars,
  ...
}: let
  dataFolder = config.xdg.dataHome;
  configFolder = config.xdg.configHome;
  cacheFolder = config.xdg.cacheHome;
in rec {
  home.homeDirectory = "/home/${myvars.username}";

  # environment variables that always set at login
  home.sessionVariables = {
    # clean up ~
    LESSHISTFILE = cacheFolder + "/less/history";
    LESSKEY = configFolder + "/less/lesskey";
    WINEPREFIX = dataFolder + "/wine";

    # set default applications
    BROWSER = "firefox";

    # enable scrolling in git diff
    DELTA_PAGER = "less -R";
  };
}