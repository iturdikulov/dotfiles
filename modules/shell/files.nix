{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.files;
    configDir = config.dotfiles.configDir;
    nnn = (pkgs.nnn.override({ withNerdIcons = true; }));
    nnnPlugins = pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v5.0";
          sha256 = "sha256-HShHSjqD0zeE1/St1Y2dUeHfac6HQnPFfjmFvSuEXUA=";
        } + "/plugins";
in {
  options.modules.shell.files = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      # use shell script to avoid creating nnn desktop file (some issues with
      # xdg-open)
      (writeShellScriptBin "nnn" ''
          export NNN_PLUG = "i:imgview;d:dragdrop;D:dups;c:chksum;f:fzcd;F:fixname;m:mymount;M:mtpmount;o:oldbigfile;R:rsync;s:suedit";
          ${getExe' nnn "nnn"} "$@"
      '')

      pcmanfm

      xdragon  # supporting dragdrop nnn plugin
      ffmpeg-full # ffmpeg-full
      ffmpegthumbnailer
      rsync    # better copy/paste
      # imgview dependencies
      nsxiv
      nix-index # Files database for nixpkgs

      dos2unix  # text file format converters
      ncdu
      file
      fd
      ripgrep
      ripgrep-all
      redis
    ];

    home.configFile = {
      # Service files, verify them when you change plugins revision
      "nnn/plugins/.cbcp".source = nnnPlugins + "/.cbcp";
      "nnn/plugins/.iconlookup".source = nnnPlugins + "/.iconlookup";
      "nnn/plugins/.nmv".source = nnnPlugins + "/.nmv";
      "nnn/plugins/.nnn-plugin-helper".source = nnnPlugins + "/.nnn-plugin-helper";
      "nnn/plugins/.ntfy".source = nnnPlugins + "/.ntfy";

      # My plugins
      "nnn/plugins/mymount".source = "${configDir}/nnn/plugins/mymount";

      # NNN plugins
      "nnn/plugins/imgview".source = nnnPlugins + "/imgview";
      "nnn/plugins/dragdrop".source = nnnPlugins + "/dragdrop";
      "nnn/plugins/dups".source = nnnPlugins + "/dups";
      "nnn/plugins/chksum".source = nnnPlugins + "/chksum";
      "nnn/plugins/fzcd".source = nnnPlugins + "/fzcd";
      "nnn/plugins/fixname".source = nnnPlugins + "/fixname";
      "nnn/plugins/mtpmount".source = nnnPlugins + "/mtpmount";
      "nnn/plugins/oldbigfile".source = nnnPlugins + "/oldbigfile";
      "nnn/plugins/rsync".source = nnnPlugins + "/rsync";
      "nnn/plugins/suedit".source = nnnPlugins + "/suedit";
    };

    # Add nnn plugins to PATH
    env.PATH = [ "${configDir}/nnn/plugins" ];
  };
}