{myvars, mylib, disko, ...}:
#############################################################
#
#  Eren - Main computer, with NixOS + i5-9400f + RX5700 + 1T storate, for daily use
#
#############################################################
let
  hostName = "eren"; # Define your hostname.
in {
  imports = [
    ./hardware-configuration.nix
    ./impermanence.nix
    ./disko.nix
    disko.nixosModules.default
  ];

  networking.wireless = {
    enable = true;
    networks."132101-1_5G".psk = "xhy18283116069";
  };
  networking.networkmanager.enable = false;

  networking = {
    inherit hostName;
    hostId = builtins.substring 0 8 (
      builtins.hashString "sha256" hostName
    );
  };

 #  networking = {
 #    inherit hostName;
 #    inherit (myvars.networking) defaultGateway nameservers;
 #    inherit (myvars.networking.hostsInterface.${hostName}) interfaces;

 #    # desktop need its cli for status bar
 #    networkmanager.enable = true;
 #  };

  # conflict with feature: containerd-snapshotter
  # virtualisation.docker.storageDriver = "btrfs";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
