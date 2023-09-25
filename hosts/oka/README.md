## Overview

Used for:

## Specs

## Installation
```sh
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- mkpart primary 512MiB 100%
parted /dev/sda -- set 1 boot on
mkfs.fat -F32 -n BOOT /dev/sda1
mkfs.ext4 -L nixos /dev/sda2
```

# Set up encrypted volume
```sh
parted /dev/sdb -- mklabel gpt
parted /dev/sdb -- mkpart primary 2048s 100%
cryptsetup -v -y luksFormat /dev/sdb1
cryptsetup luksOpen /dev/sdb1 backup
mkfs.ext4 -L backup /dev/sdb1
```

# Mount drives
```sh
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/BOOT /mnt/boot
mount /dev/mapper/backup /mnt/backup
```