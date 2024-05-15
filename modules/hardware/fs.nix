{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.fs;
in {
  options.modules.hardware.fs = {
    enable = mkBoolOpt false;
    zfs.enable = mkBoolOpt false;
    ssd.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.udevil.enable = true;

      # Support for more filesystems, mostly to support external drives
      environment.systemPackages = with pkgs; [
        sshfs
        detox     # Tames problematic filenames
        entr      # Run arbitrary commands when files change
        watchman  # Watch files and record when they change. It can also trigger actions
        exfat     # Windows drives
        ntfs3g    # Windows drives
        hfsprogs  # MacOS drives
        glib       # To mount android devices, using gio
        cryptsetup  # LUKS for dm-crypt, encryption support
        smartmontools # Tools for monitoring the health of hard drives
        fdupes        # Identifies duplicate files residing within specified directories
      ];
    }

    (mkIf (!cfg.zfs.enable && cfg.ssd.enable) {
      services.fstrim.enable = true;
    })

    (mkIf cfg.zfs.enable (mkMerge [
      {
        boot.loader.grub.copyKernels = true;
        boot.supportedFilesystems = [ "zfs" ];
        boot.zfs.devNodes = "/dev/disk/by-partuuid";
        services.zfs.autoScrub.enable = true;
      }

      (mkIf cfg.ssd.enable {
        # Will only TRIM SSDs; skips over HDDs
        services.fstrim.enable = false;
        services.zfs.trim.enable = true;
      })
    ]))
  ]);
}