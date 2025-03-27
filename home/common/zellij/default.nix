{pkgs, ...}: let
  shellAliases = {
    "zj" = "zellij";
  };
in {
  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
  };

  # only works in bash/zsh, not nushell
  home.shellAliases = shellAliases;

  # TODO: use default config for now
#   xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}