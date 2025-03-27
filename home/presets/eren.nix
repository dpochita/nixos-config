{
  imports = [
    # basic
    ../common
    # Tiling window manager
    ../linux/hyprland
    # Shell environment
    ../linux/shell.nix
  ];
  # Hyprland setting
  modules.desktop = {
    hyprland = {
      settings = {
        # Configure your Display resolution, offset, scale and Monitors here, use `hyprctl monitors` to get the info.
        #   highres:      get the best possible resolution
        #   auto:         position automatically
        #   1.5:          scale to 1.5 times
        #   bitdepth,10:  enable 10 bit support
        # TODO: change the info
        # monitor = "DP-2,highres,auto,1.5,bitdepth,10";
      };
    };
  };
}