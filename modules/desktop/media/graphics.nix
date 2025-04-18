# modules/desktop/media/graphics.nix

{ config, options, inputs, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.graphics;
    configDir = config.dotfiles.configDir;
    blenderVersion = "4.3";
    screenScaleFactor = config.modules.desktop.high-dpi.scaleFactor;
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
    davinci.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.models.enable {
      # Supplies newer versions of Blender with CUDA support baked in.
      # @see https://github.com/edolstra/nix-warez/tree/master/blender
      nixpkgs.overlays = [ inputs.blender-bin.overlays.default ];

      # 3D modelling & 3D printing
      user.packages = with pkgs; [
          f3d                   # Fast and minimalist 3D viewer using VTK
          unstable.freecad-wayland  # General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler
          openscad-unstable
          # TODO: verify libcrypt-legacy is required
          # Blender itself doesn't need libxcrypt-legacy, but I use blenderkit,
          # which needs libcrypt.so.1, which libxcrypt no longer provides.
          pkgs."blender_${builtins.replaceStrings ["."] ["_"] blenderVersion}"
          solvespace
          fspy                  # Quick and easy still image camera matching
          unstable.orca-slicer
        ];

      # OpenSCAD libraries
      home.dataFile."OpenSCAD/libraries/Round-Anything" = {
        source = pkgs.fetchFromGitHub {
          owner = "Irev-Dev";
          repo = "Round-Anything";
          rev = "refs/heads/master";
          hash = "sha256-xED5fz+VmVv4VJO72PQuExqOtxFdCQ4v4GA99GvA70E=";
        };
        recursive = true;
      };

      # I copy these files manually because they should be mutable, as Blender is
      # very stateful. Having a consistent starting point for new systems is good
      # enough for me.
      system.userActivationScripts.setupBlenderConfig = ''
        src="${configDir}/blender/initial_configuration.7z"
        destdir="$XDG_CONFIG_HOME/blender/${blenderVersion}"

        # Exit if the config directory already exists
        if [ -d "$destdir" ]; then
            echo "Config directory already exists, skipping setup"
            exit 0
        fi

        # Extract the config directory with startup files
        mkdir -p "$destdir"
        ${getExe' pkgs._7zz "7zz"} x "$src" -o"$destdir"
      '';
    })

    {
      user.packages = with pkgs;
        (if cfg.tools.enable then [
          font-manager         # for easily toggling and previewing groups of fonts
          unstable.imagemagick # for CLI image manipulation

          image_optim    # Optimize images using multiple utilities
          tesseract4     # OCR engine
          gImageReader   # Simple Gtk/Qt front-end to tesseract-ocr
          flameshot      # Screenshots
        ] else []) ++

        # Replaces Illustrator (maybe indesign?)
        (if cfg.vector.enable then [
          inkscape-with-extensions
        ] else []) ++

        (if screenScaleFactor != null then [
            (makeDesktopItem {
                name = "krita";
                desktopName = "Krita";
                genericName = "Digital Painting";
                icon = "krita";
                exec = "env QT_SCALE_FACTOR=${screenScaleFactor} ${krita}/bin/krita %F";
                categories = [ "Graphics" "Photography" ];
            })
            (writeShellScriptBin "krita" ''
                export QT_SCALE_FACTOR=${screenScaleFactor}  # fix on high DPI screens
                exec ${krita}/bin/krita "$@"
            '')
        ] else [krita]) ++

        # Raster images workflow
        (if cfg.raster.enable then [
          geeqie
          qview  # has nice integration with geeqie
          librsvg
          nodePackages.svgo
          pureref
          (makeDesktopItem {
            name = "pureref";
            desktopName = "PureRef";
            genericName = "Simple reference image viewer";
            icon = "pureref";
            exec = "env QT_SCALE_FACTOR=${screenScaleFactor} ${getExe' pkgs.pureref "pureref"} %F";
            categories = [ "Graphics" "Photography" ];
          })

          # FIXME: on some point need to remove this and add gimp 3.0
          # this using manually gimp 2.99 build
          # also this directory is exclued from VCS and you need to copy
          # files manually across machines
          (makeDesktopItem {
            name = "gimp";
            desktopName = "GIMP";
            genericName = "GNU Image Manipulation Program";
            icon = "gimp";
            exec = "env GDK_BACKEND=x11 ${config.user.home}/.local/bin/gimp/result/bin/gimp %F";
            categories = [ "Graphics" "Photography" ];
          })
        ] else []) ++

        # Sprite sheets & animation
        (if cfg.sprites.enable then [
          aseprite-unfree
        ] else []) ++

        # Photography workflow
        (if cfg.photos.enable then [
          darktable
          imv
        ] else []) ++

        # Video editing
        (if cfg.videos.enable then [
          losslesscut-bin
          kdePackages.kdenlive
        ] else []) ++

        (if cfg.davinci.enable then [
          davinci-resolve
        ] else []);

      home.configFile = mkIf cfg.raster.enable {
        "GIMP/2.10" = { source = "${configDir}/gimp"; recursive = true; };
      };

      # Fix krita styling
      env.KRITA_NO_STYLE_OVERRIDE = "1";
    }
  ]);
}