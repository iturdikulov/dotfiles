{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  devCfg = config.modules.dev;
  cfg = devCfg.fhs-compat;
in
{
  options.modules.dev.fhs-compat = {
    enable = mkBoolOpt false;
    withGraphics = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.envfs.enable = lib.mkDefault true;

    programs.nix-ld.enable = lib.mkDefault true;
    programs.nix-ld.libraries =
      with pkgs;
      [
        acl
        attr
        bzip2
        dbus
        expat
        fontconfig
        freetype
        fuse3
        icu
        libnotify
        libsodium
        libssh
        libunwind
        libusb1
        libuuid
        nspr
        nss
        stdenv.cc.cc
        util-linux
        zlib
        zstd
      ]
      ++ lib.optionals (cfg.withGraphics) [
        pipewire
        cups
        libxkbcommon
        pango
        mesa
        libdrm
        libglvnd
        libpulseaudio
        atk
        cairo
        alsa-lib
        at-spi2-atk
        at-spi2-core
        gdk-pixbuf
        glib
        gtk3
        libGL
        libappindicator-gtk3
        vulkan-loader
        # xorg.libX11
        # xorg.libXScrnSaver
        # xorg.libXcomposite
        # xorg.libXcursor
        # xorg.libXdamage
        # xorg.libXext
        # xorg.libXfixes
        # xorg.libXi
        # xorg.libXrandr
        # xorg.libXrender
        # xorg.libXtst
        # xorg.libxcb
        # xorg.libxkbfile
        # xorg.libxshmfence
      ];
  };
}