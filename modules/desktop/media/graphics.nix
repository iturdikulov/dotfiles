# modules/desktop/media/graphics.nix
#
# The hardest part about switching to linux? Sacrificing Adobe. It really is
# difficult to replace and its open source alternatives don't *quite* cut it,
# but enough that I can do a fraction of it on Linux. For the rest I have a
# second computer dedicated to design work (and gaming).

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

  config = mkIf cfg.enable {
    user.packages = with pkgs;
      (if cfg.tools.enable then [
        font-manager   # so many damned fonts...
        imagemagick    # for image manipulation from the shell
        tesseract4     # OCR engine
        maim           # A command-line screenshot utility
        (pkgs.writeScriptBin "scrcap_ocr" ''
        #!/bin/sh
        maim -s | convert - -units PixelsPerInch -resample 300 -sharpen 12x6.0 - \
        | tesseract -l eng+rus stdin stdout \
        | xclip -in -selection clipboard
        notify-send "Screenshot OCR" "Image copied to clipboard"
        '')
      ] else []) ++

      # replaces illustrator & indesign
      (if cfg.vector.enable then [
        unstable.inkscape
      ] else []) ++

      # raster images workflow
      (if cfg.raster.enable then [
        # nsxiv image viewer
        nsxiv
        libwebp  # required for animated webp playback
        giflib   # used for animated gif playback

        krita
        gimp
        # gimpPlugins.resynthesizer  # content-aware scaling in gimp
      ] else []) ++

      # Sprite sheets & animation
      (if cfg.sprites.enable then [
        aseprite-unfree
      ] else []) ++

      # 3D modelling
      (if cfg.models.enable then [
        blender-hip
      ] else []) ++

      # Photography workflow
      (if cfg.photos.enable then [
        darktable
      ] else [])++

      # Video editing
      (if cfg.videos.enable then [
        olive-editor
        natron
      ] else []);

    home.configFile = mkIf cfg.raster.enable {
      "GIMP/2.10" = { source = "${configDir}/gimp"; recursive = true; };
    };
  };
}