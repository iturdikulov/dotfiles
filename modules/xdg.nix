# xdg.nix
#
# Set up and enforce XDG compliance. Other modules will take care of their own,
# but this takes care of the general cases.

{ options, config, pkgs, lib, home-manager, ... }:

with lib;
with lib.my;
let cfg = config.xdg;
in {
  options.xdg = {
    enable = mkBoolOpt true;
    mimeapps.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      ### A tidy $HOME is a tidy mind
      home-manager.users.${config.user.name}.xdg.enable = true;

      # Auto-create XDG directories and ensure correct permissions. Some tools
      # may auto-create them with overly permissive defaults OR may not create
      # them at all when trying to write them, causing errors. Best to do it
      # right from the start.
      system.userActivationScripts.wacom = ''
        for dir in $XDG_STATE_HOME $XDG_DATA_HOME $XDG_CACHE_HOME $XDG_BIN_HOME $XDG_CONFIG_HOME; do
          mkdir -p $dir
          chmod 700 $dir
        done
      '';

      environment = {
        sessionVariables = {
          # Prevent auto-creation of XDG user directories (like Desktop,
          # Documents, etc), we move it to $XDG_DATA_HOME. The trailing slash is
          # necessary for some apps (like Firefox) to respect it. See
          # https://bugzilla.mozilla.org/show_bug.cgi?id=1082717
          XDG_DESKTOP_DIR = "$HOME/.local/share/xdg/desktop/";

          # These are the defaults, and xdg.enable does set them, but due to load
          # order, they're not set before environment.variables are set, which could
          # cause race conditions.
          XDG_CACHE_HOME = "$HOME/.cache";
          XDG_CONFIG_HOME = "$HOME/.config";
          XDG_BIN_HOME = "$HOME/.local/bin";
          XDG_DATA_HOME = "$HOME/.local/share";
          XDG_STATE_HOME = "$HOME/.local/state";
        };

        # Some programs ignore the envvars (like apps with Gnome/QT
        # compatibilty, or certain file managers) and end up auto-creating these
        # annoying directories in $HOME. I would rather impose my own structure
        # on $HOME, so I stow them away in $XDG_DATA_HOME.
        etc."xdg/user-dirs.defaults".text = ''
          XDG_DESKTOP_DIR="$HOME/.local/share/xdg/desktop"
          XDG_DOCUMENTS_DIR="$HOME/.local/share/xdg/documents"
          XDG_DOWNLOAD_DIR="$HOME/downloads"
          XDG_MUSIC_DIR="$HOME/.local/share/xdg/music"
          XDG_PICTURES_DIR="$HOME/.local/share/xdg/pictures"
          XDG_PUBLICSHARE_DIR="$HOME/.local/share/xdg/share"
          XDG_TEMPLATES_DIR="$HOME/.local/share/xdg/templates"
          XDG_VIDEOS_DIR="$HOME/.local/share/xdg/videos"
        '';

        variables = {
          # Conform more programs to XDG conventions. The rest are handled by their
          # respective modules.
          __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
          ASPELL_CONF = ''
            per-conf $XDG_CONFIG_HOME/aspell/aspell.conf;
            personal $XDG_CONFIG_HOME/aspell/en_US.pws;
            repl $XDG_CONFIG_HOME/aspell/en.prepl;
          '';
          DVDCSS_CACHE = "$XDG_DATA_HOME/dvdcss";
          HISTFILE = ''$XDG_STATE_HOME/''${SHELL##*/}/history'';
          INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
          LESSHISTFILE = "$XDG_STATE_HOME/less/history";
          LESSKEY = "$XDG_CONFIG_HOME/less/keys";
          WGETRC = "$XDG_CONFIG_HOME/wgetrc";
          # Common shells
          BASH_COMPLETION_USER_FILE = "$XDG_CONFIG_HOME/bash/completion";
          ENV = "$XDG_CONFIG_HOME/shell/shrc"; # sh, ksh
          # SQL
          MYSQL_HISTFILE = "$XDG_STATE_HOME/mysql/history";
          PGPASSFILE = "$XDG_CONFIG_HOME/pg/pgpass";
          PGSERVICEFILE = "$XDG_CONFIG_HOME/pg";
          PSQLRC = "$XDG_CONFIG_HOME/pg/psqlrc";
          PSQL_HISTORY = "$XDG_STATE_HOME/psql_history";
          # Tools I don't use
          BZRPATH = "$XDG_CONFIG_HOME/bazaar";
          BZR_HOME = "$XDG_CACHE_HOME/bazaar";
          BZR_PLUGIN_PATH = "$XDG_DATA_HOME/bazaar";
          ICEAUTHORITY = "$XDG_CACHE_HOME/ICEauthority";
          SUBVERSION_HOME = "$XDG_CONFIG_HOME/subversion";
        };
      };

      ## dbus-broker doesn't produce a $HOME/.dbus like the dbus daemon does.
      services.dbus.implementation = "broker";

      # Ensure legacy GTK2 apps read/write its config to an XDG directory.
      # services.xserver.displayManager.job.environment.GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
      # The authoritative way to inform the display manager of this file's new
      # location, and soon enough.
      # systemd.globalEnvironment.XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
      # services.xserver.displayManager.job.environment.XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
      # See https://kdemonkey.blogspot.com/2008/04/magic-trick.html, then
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/x11/display-managers/default.nix#L74-L83
      # which would otherwise create $HOME/.compose-cache.
      services.xserver.displayManager.job.environment.XCOMPOSECACHE = "$XDG_RUNTIME_DIR/xcompose";
    }

    (mkIf cfg.mimeapps.enable {
      # Bind mimetypes to applications
      # !IMPORTANT!
      # you can get the mimetype with this command
      # export XDG_UTILS_DEBUG_LEVEL=2
      # xdg-mime query default application/pdf
      # xdg-mime query filetype file.ext
      home-manager.users.${config.user.name}.xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          # TODO: check raster/svg/etc enabled and only then apply associations?

          "inode/directory" = "nnn-xst.desktop"; # directory

          # Default browser & html files
          "x-scheme-handler/http" = "brave-browser.desktop";
          "x-scheme-handler/https" = "brave-browser.desktop";
          "x-scheme-handler/about" = "brave-browser.desktop";
          "x-scheme-handler/ftp" = "filezilla.desktop";
          "x-scheme-handler/unknown" = "brave-browser.desktop";
          "text/html" = "brave-browser.desktop"; # html5.html
          "application/xhtml+xml" = "brave-browser.desktop"; # xhtml5.xhtml

          # Documents
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "writer.desktop" ]; # docx.docx
          "application/vnd.oasis.opendocument.text" = [ "writer.desktop" ]; # odt.odt

          "application/pdf" = [ "sioyek.desktop" ]; # pdf.pdf
          "application/epub+zip" = [ "org.pwmt.zathura-cb.desktop" ]; # epub.epub
          "application/x-fictionbook+xml" = [ "org.pwmt.zathura-cb.desktop" ]; # fictionbook.fb2
          "application/x-mobipocket-ebook" = [ "org.pwmt.zathura-cb.desktop" ]; # mobi.mobi
          "application/vnd.ms-htmlhelp" = [ "xchm.desktop" ]; # compiledhtml.chm
          "application/x-cb7" = [ "org.pwmt.zathura-cb.desktop" ]; # comix.cb7
          "application/vnd.comicbook-rar" = [ "org.pwmt.zathura-cb.desktop" ]; # comix.cbr
          "application/x-cbt" = [ "org.pwmt.zathura-cb.desktop" ]; # comix.cbt
          "application/vnd.comicbook+zip" = [ "org.pwmt.zathura-cb.desktop" ]; # comix.cbz
          "application/postscript" = [ "org.pwmt.zathura-ps.desktop" ]; # ps.ps
          "image/vnd.djvu+multipage" = [ "org.pwmt.zathura-djvu.desktop" ]; # djvu.djvu

          # Text Files Associated with nvim (and some other types)
          "text/x-adasrc" = [ "nvim.desktop" ]; # ada.adb
          "application/x-shellscript" = [ "nvim.desktop" ]; # shell.sh
          "application/toml" = [ "nvim.desktop" ]; # toml.toml
          "application/xml" = [ "nvim.desktop" ]; # xml-1.1.xml
          "application/x-yaml" = [ "nvim.desktop" ]; # yaml.yml
          "application/x-ruby" = [ "nvim.desktop" ]; # ruby.rb
          "application/x-awk" = [ "nvim.desktop" ]; # awk.awk
          "application/x-perl" = [ "nvim.desktop" ]; # perl.pl
          "application/x-php" = [ "nvim.desktop" ]; # php.php
          "application/vnd.coffeescript" = [ "nvim.desktop" ]; # coffeescript.coffee
          "application/json" = [ "nvim.desktop" ]; # json.json
          "application/javascript" = [ "nvim.desktop" ]; # javascript.js
          "text/plain" = [ "nvim.desktop" ]; # batch.bat
          "text/x-csrc" = [ "nvim.desktop" ]; # c.c
          "text/x-chdr" = [ "nvim.desktop" ]; # c.h
          "text/x-cobol" = [ "nvim.desktop" ]; # cobol.cob
          "text/x-c++src" = [ "nvim.desktop" ]; # cpp.cpp
          "text/x-crystal" = [ "nvim.desktop" ]; # crystal.cr
          "text/x-csharp" = [ "nvim.desktop" ]; # csharp.cs
          "text/css" = [ "nvim.desktop" ]; # css.css
          "text/x-eiffel" = [ "nvim.desktop" ]; # eiffel.e
          "text/x-elixir" = [ "nvim.desktop" ]; # elixir.ex
          "text/x-fortran" = [ "nvim.desktop" ]; # fortran-90.f90
          "text/x-go" = [ "nvim.desktop" ]; # go.go
          "text/x-groovy" = [ "nvim.desktop" ]; # groovy.groovy
          "text/x-haskell" = [ "nvim.desktop" ]; # haskell_loop.hs
          "text/x-java" = [ "nvim.desktop" ]; # java.java
          "text/x-lua" = [ "nvim.desktop" ]; # lua.lua
          "text/x-makefile" = [ "nvim.desktop" ]; # Makefile
          "text/markdown" = [ "nvim.desktop" ]; # markdown.md
          "text/x-objcsrc" = [ "nvim.desktop" ]; # objective-c.m
          "text/x-ocaml" = [ "nvim.desktop" ]; # ocaml.ml
          "text/x-pascal" = [ "nvim.desktop" ]; # pascal.pas
          "text/x-python" = [ "nvim.desktop" ]; # python.py
          "text/rust" = [ "nvim.desktop" ]; # rust.rs
          "text/x-scala" = [ "nvim.desktop" ]; # scala.scala
          "text/vnd.trolltech.linguist" = [ "nvim.desktop" ]; # typescript.ts

          # Raster Images
          "image/x-eps" = [ "org.pwmt.zathura-cb.desktop" ]; # eps.eps
          "image/jp2" = [ "org.darktable.darktable.desktop" ]; # jpeg2.jp2, nsxiv can't open it
          "image/webp" = [ "com.interversehq.qView.desktop" ]; # webp.webp
          "image/jpeg" = [ "com.interversehq.qView.desktop" ]; # jpeg.jpg
          "image/png" = [ "com.interversehq.qView.desktop" ]; # png-transparent.png
          "image/tiff" = [ "com.interversehq.qView.desktop" ]; # tiff.tif
          "image/gif" = [ "com.interversehq.qView.desktop" ]; # gif-transparent.gif
          "image/bmp" = [ "com.interversehq.qView.desktop" ]; # bmp.bmp
          "image/vnd.microsoft.icon" = [ "com.interversehq.qView.desktop" ]; # ico.ico
          "image/heif" = [ "com.interversehq.qView.desktop" ]; # heif.heif
          "image/x-portable-bitmap" = [ "com.interversehq.qView.desktop" ]; # pbm.pbm
          "image/x-portable-graymap" = [ "com.interversehq.qView.desktop" ]; # pgmb.pgm
          "image/x-tga" = [ "com.interversehq.qView.desktop" ]; # targa.tga
          "image/jxl" = [ "com.interversehq.qView.desktop" ]; # jxl.jxl
          "image/x-xbitmap" = [ "com.interversehq.qView.desktop" ]; # x-bitmap.xbm
          "image/x-portable-pixmap" = [ "com.interversehq.qView.desktop" ]; # ppmb.ppm

          # Vector Images
          "image/wmf" = [ "org.inkscape.Inkscape.desktop" ]; # WindowsMetafile.wmf
          "image/svg+xml" = [ "org.inkscape.Inkscape.desktop" ]; # svg.svg

          # Multimedia
          "application/x-cue" = [ "mpv.desktop" ]; # cue.cue
          "application/vnd.adobe.flash.movie" = [ "mpv.desktop" ]; # flash.swf
          "video/mpeg" = [ "mpv.desktop" ]; # video.mpg
          "video/x-matroska" = [ "mpv.desktop" ]; # video.mkv
          "video/x-msvideo" = [ "mpv.desktop" ]; # AudioVideoInterleave.avi
          "video/x-flv" = [ "mpv.desktop" ]; # FlashVideo.flv
          "video/mp4" = [ "mpv.desktop" ]; # mp4-with-audio.mp4
          "audio/mp4" = [ "mpv.desktop" ]; # m4a.m4a
          "audio/x-m4a" = [ "mpv.desktop" ]; # m4a.m4a
          "audio/x-m4b" = [ "mpv.desktop" ]; # m4b.m4b
          "video/x-ms-wmv" = [ "mpv.desktop" ]; # WindowsMediaVideo.wmv
          "video/webm" = [ "mpv.desktop" ]; # webm.webm
          "audio/flac" = [ "mpv.desktop" ]; # flac.flac
          "audio/vnd.wav" = [ "mpv.desktop" ]; # wav.wav
          "audio/x-wav" = [ "mpv.desktop" ]; # wav.wav
          "audio/mpeg" = [ "mpv.desktop" ]; # mp3.mp3

          # Archives and octet-stream
          "application/octet-stream" = [ "xarchiver.desktop" ]; # unknow files, TODO: better use here universal viewer tool?
          "application/gzip" = [ "xarchiver.desktop" ]; # gzip.gz
          "application/x-bzip" = [ "xarchiver.desktop" ]; # bzip2.bz2
          "application/zstd" = [ "xarchiver.desktop" ]; # zstd.zstd
          "application/vnd.rar" = [ "xarchiver.desktop" ]; # rar5.rar
          "application/x-7z-compressed" = [ "xarchiver.desktop" ]; # 7zip.7z
          "application/zip" = [ "xarchiver.desktop" ]; # zip.zip
          "application/x-tar" = [ "xarchiver.desktop" ]; # tar.tar
        };
      };
    })

    # NEXT: need verify this in https://github.com/hlissner
    ## Getting SSH to respect XDG -- HIGHLY EXPERIMENTAL. Expect jank.
  ]);
}