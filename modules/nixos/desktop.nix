{
  pkgs,
  myvars,
  ...
}:
{
  imports = [
    # nixos base
    ./base
    # all platform common pkgs
    ../common.nix
    # load all gui modules
    ./gui
  ];
  ####################################################################
  #  NixOS's Configuration for Wayland based Window Manager
  ####################################################################
 
  xdg.portal.config.common.default = "*"; 

  services = {
    xserver.enable = false; # disable xorg server
    # https://wiki.archlinux.org/title/Greetd
    greetd = {
        enable = true;
        settings = {
        default_session = {
            # Wayland Desktop Manager is installed only for user ryan via home-manager!
            user = myvars.username;
            # .wayland-session is a script generated by home-manager, which links to the current wayland compositor(sway/hyprland or others).
            # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config here.
            command = "$HOME/.wayland-session"; # start a wayland session directly without a login manager
            # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd $HOME/.wayland-session";  # start wayland session with a TUI login manager
        };
        };
    };
  };
  
  # fix https://github.com/ryan4yin/nix-config/issues/10
  security.pam.services.swaylock = {};
}
