{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.files;
in {
  options.modules.shell.files = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      # NNN
      (nnn.override {withNerdIcons = true;})
      (makeDesktopItem {
        name = "nnn-xst";
        desktopName = "NNN xst";
        genericName = "NNN xst";
        icon = "utilities-terminal";
        exec = "${xst}/bin/xst -e nnn %F";
        categories = [ "Development" "System" "Utility" ];
      })

      xdragon  # supporting dragdrop nnn plugin
      ffmpeg-full # ffmpeg-full
      ffmpegthumbnailer
      rsync    # better copy/paste
      # imgview dependencies
      nsxiv

      dos2unix  # text file format converters
      ncdu
      file
      fd
      ripgrep
      redis
    ];

    # NNN plugins setup
    env.NNN_PLUG = "i:imgview;d:dragdrop;D:dups;c:chksum;f:fzcd;F:fixname;m:mp3conv;o:oldbigfile;R:rsync;s:suedit";
    home.configFile = {
      "nnn/plugins" = {
        source = pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v4.9";
          sha256 = "sha256-g19uI36HyzTF2YUQKFP4DE2ZBsArGryVHhX79Y0XzhU=";
        } + "/plugins";
        recursive = true;
      };
    };
  };
}