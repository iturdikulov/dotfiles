# modules/desktop/media/graphics.nix

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.graphics;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.media.graphics = {
    enable         = mkBoolOpt false;
    tools.enable   = mkBoolOpt true;
    raster.enable  = mkBoolOpt true;
    vector.enable  = mkBoolOpt true;
    sprites.enable = mkBoolOpt true;
    models.enable  = mkBoolOpt true;
    photos.enable  = mkBoolOpt true;
    videos.enable  = mkBoolOpt true;
  };

  config = mkIf cfg.enable (mkMerge [

    (mkIf cfg.models.enable {
      # 3D modelling
      user.packages = with pkgs; [
          f3d                   # Fast and minimalist 3D viewer using VTK
          unstable.blender-hip
          solvespace
          fspy                  # Quick and easy still image camera matching
      ];

      # I copy these files manually because they should be mutable, as Blender is
      # very stateful. Having a consistent starting point for new systems is good
      # enough for me.
      system.userActivationScripts.setupBlenderConfig = ''
        # Copy scripts
        scriptsDest="$XDG_CONFIG_HOME/blender/4.2/"
        mkdir -p "$scriptsDest"
        cp -r ${configDir}/blender/scripts "$scriptsDest"

        # Copy config
        destdir="$XDG_CONFIG_HOME/blender/4.2/config"
        mkdir -p "$destdir"
        for cfile in ${configDir}/blender/config/*; do
          basename="$(basename $cfile)"
          dest="$destdir/$basename"
          if [ ! -e "$dest" ]; then
            cp "$cfile" "$dest"
          fi
        done
        for bfile in startup userpref; do
          src="${configDir}/blender/$bfile.blend.tar.gz"
          if [ ! -e "$destdir/$bfile.blend" ]; then
            ${pkgs.gnutar}/bin/tar xzvf "$src" -C "$destdir"
          fi
        done
      '';
    })

    {
      user.packages = with pkgs;
        (if cfg.tools.enable then [
          font-manager         # for easily toggling and previewing groups of fonts
          unstable.imagemagick # for CLI image manipulation

          image_optim    # Optimize images using multiple utilities
          tesseract4     # OCR engine
          maim           # A command-line screenshot utility
          gpick          # An advanced color picker
          flameshot      # Screenshots

          # pureref        # A reference image viewer
          #(makeDesktopItem {
          #  name = "pureref";
          #  desktopName = "pureref";
          #  genericName = "A reference image viewer";
          #  icon = "pureref";
          #  exec = "${pkgs.pureref}/bin/pureref %F";
          #})

          (pkgs.writeScriptBin "scrcap_ocr" ''
          #!/bin/sh
          maim -s | convert - -units PixelsPerInch -resample 300 -sharpen 12x6.0 - \
          | tesseract -l eng+rus stdin stdout \
          | xclip -in -selection clipboard
          notify-send "Screenshot OCR" "Image copied to clipboard"
          '')
        ] else []) ++

        # Replaces Illustrator (maybe indesign?)
        (if cfg.vector.enable then [
          inkscape-with-extensions
        ] else []) ++

        # Raster images workflow
        (if cfg.raster.enable then [
          krita
          gimp
          gimpPlugins.gmic
          gimpPlugins.bimp
          qview
          geeqie
          librsvg
          nodePackages.svgo
        ] else []) ++

        # Sprite sheets & animation
        (if cfg.sprites.enable then [
          aseprite-unfree
        ] else []) ++

        # Photography workflow
        (if cfg.photos.enable then [
          darktable
        ] else []) ++

        # Video editing
        (if cfg.videos.enable then [
          losslesscut-bin
          kdenlive
        ] else []);

      home.configFile = mkIf cfg.raster.enable {
        "GIMP/2.10" = { source = "${configDir}/gimp"; recursive = true; };
      };

      # Fix krita styling
      env.KRITA_NO_STYLE_OVERRIDE = "1";
    }
  ]);
}
