{
  impermanence,
  pkgs,
  ...
}: {
  imports = [
    impermanence.nixosModules.impermanence
  ];

  environment.systemPackages = [
    # `sudo ncdu -x /`
    pkgs.ncdu
  ];

  # There are two ways to clear the root filesystem on every boot:
  ##  1. use tmpfs for /
  ##  2. (btrfs/zfs only)take a blank snapshot of the root filesystem and revert to it on every boot via:
  ##     boot.initrd.postDeviceCommands = ''
  ##       mkdir -p /run/mymount
  ##       mount -o subvol=/ /dev/disk/by-uuid/UUID /run/mymount
  ##       btrfs subvolume delete /run/mymount
  ##       btrfs subvolume snapshot / /run/mymount
  ##     '';
  #
  #  See also https://grahamc.com/blog/erase-your-darlings/

  # NOTE: impermanence only mounts the directory/file list below to /persistent
  # If the directory/file already exists in the root filesystem, you should
  # move those files/directories to /persistent first!
  environment.persistence."/persistent" = {
    # sets the mount option x-gvfs-hide on all the bind mounts
    # to hide them from the file manager
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/etc/nix/inputs"
      # my secrets

      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/zfs/zpool.cache"
    ];

    # the following directories will be passed to /persistent/home/$USER
    users.songlin = {
      directories = [
        "dev"
        "nix-config"
        "tmp"

        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"

        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }

        # neovim / remmina / flatpak / ...
        ".local/share"
        ".local/state"

        # language package managers
        "go"
        ".cargo" # rust
        ".m2" # maven
        ".gradle" # gradle
      ];
    };
  };
}
