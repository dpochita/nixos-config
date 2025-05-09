{
  pkgs,
  config,
  lib,
  ...
} @ args:
with lib; let
  cfg = config.modules.desktop.hyprland;
in {
  options.modules.desktop.hyprland = {
    enable = mkEnableOption "hyprland compositor";
    settings = lib.mkOption {
      type = with lib.types; let
        valueType =
          nullOr (oneOf [
            bool
            int
            float
            str
            path
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {
            description = "Hyprland configuration value";
          };
      in
        valueType;
      default = {};
    };
  };

  config =mkMerge([{ wayland.windowManager.hyprland.settings = cfg.settings; }] ++ (import ./settings args));
}
