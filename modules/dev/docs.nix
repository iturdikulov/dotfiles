{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;

let devCfg = config.modules.dev;
    cfg = devCfg.docs;
    configDir = config.dotfiles.configDir;
in {
  options.modules.dev.docs = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Libraries and development utilities might provide additional documentation
    # and manpages. You can add those to your system like this
    documentation.dev.enable = true;

    # dasht docsets path
    env.DASHT_DOCSETS_DIR = "${config.user.home}/Reference/docsets";

    user.packages = with pkgs; [
      dasht    # to search in docsets from CLI
      zeal     # GUI for docsets, if need to render images
      tealdeer # Simplified, example based and community-driven man pages.
      man-pages
      man-pages-posix
    ];

    home.configFile."Zeal/Zeal.conf".source = "${configDir}/zeal/zeal.conf";
  };
}