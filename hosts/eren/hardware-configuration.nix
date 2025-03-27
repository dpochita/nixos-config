# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Use the EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;
  # depending on how you configured your disk mounts
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.systemd-boot.enable = true;

  # for impermanence
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r zroot/local/root@blank
  '';

  boot.kernelParams = [
    # https://github.com/NixOS/nixpkgs/issues/35681
    "systemd.gpt_auto=0"
    # set zfs arc max size to 4G
    "zfs.zfs_arc_max=${toString (4096 * 1048576)}"
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["kvm-intel"]; # kvm virtualization support
  boot.extraModprobeConfig = "options kvm_intel nested=1"; # for intel cpu
  boot.extraModulePackages = [];
  # clear /tmp on boot to get a stateless /tmp directory.
  boot.tmp.cleanOnBoot = true;

  # Enable binfmt emulation of aarch64-linux, this is required for cross compilation.
  boot.binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];
  # supported file systems, so we can mount any removable disks with these filesystems
  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    "zfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
  ];


  fileSystems = {
    "/var/log".neededForBoot = true;
    "/persist".neededForBoot = true;
  };
  services = {
    zfs = {
      # run `zpool trim` automatically
      trim.enable = true;
      # cannot fix error, only report
      autoScrub = {
        enable = true;
        pools = [ "zroot" ];
      };
    };
  };

  systemd = {
    enableEmergencyMode = false;

    # Explicitly disable ZFS mount service since we rely on legacy mounts
    services.zfs-mount.enable = false;

    extraConfig = ''
      DefaultTimeoutStartSec=20s
      DefaultTimeoutStopSec=10s
    '';
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
