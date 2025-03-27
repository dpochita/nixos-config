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
  modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      "modules/nixos/desktop.nix"
      # host specific
      "hosts/${name}"
    ];
    home-modules = map mylib.relativeToRoot [
      "home/presets/eren.nix"
    ];
  };
in {
  nixosConfigurations = {
    # host with hyprland compositor
    "${name}" = mylib.nixosSystem (modules // args);
  };

  # generate iso image for hosts with desktop environment
  packages = {
    "${name}" = inputs.self.nixosConfigurations."${name}".config.formats.iso;
  };
}
