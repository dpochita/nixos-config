{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, etc.
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  ...
} @ args: let
  name = "eren";
  base-modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      # todo
      # host specific
      "hosts/${name}"
    ];
    home-modules = map mylib.relativeToRoot [
      # common
      # "home/linux/gui.nix"
      # host specific
      # "hosts/${name}/home.nix"
    ];
  };

  modules-hyprland = {
    nixos-modules =
      [
        {
        #   modules.desktop.wayland.enable = true;
        }
      ]
      ++ base-modules.nixos-modules;
    home-modules =
      [
      #   {modules.desktop.hyprland.enable = true;}
      ]
      ++ base-modules.home-modules;
  };
in {
  nixosConfigurations = {
    # host with hyprland compositor
    "${name}" = mylib.nixosSystem (modules-hyprland // args);
  };

  # generate iso image for hosts with desktop environment
  packages = {
    "${name}" = inputs.self.nixosConfigurations."${name}".config.formats.iso;
  };
}
