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
      xdragon  # supporting dragdrop nnn plugin
      ffmpeg-full # ffmpeg-full
      ffmpegthumbnailer
      rsync    # better copy/paste
      # imgview dependencies
      nsxiv

      ncdu
      file
      fd
      ripgrep
      trash-cli
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