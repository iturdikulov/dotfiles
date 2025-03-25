# modules/desktop/media/docs.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.media.documents;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.media.documents = {
    enable = mkBoolOpt false;
    pdf.enable = mkBoolOpt true;
    ebook.enable = mkBoolOpt true;
    office.enable = mkBoolOpt false;
  };


  config = mkIf cfg.enable {
    # Config files
    # TODO parametrize this, with mkMerge
    home.configFile."zathura/zathurarc".source = "${configDir}/zathura/zathurarc";

    # TODO thing about dotfiles for this packages
    env.CALIBRE_USE_SYSTEM_THEME = "true";

    user.packages = with pkgs;
      (if cfg.ebook.enable then [
        xchm
        calibre
        pandoc
        my.koreader
      ] else []) ++

      (if cfg.pdf.enable then [
        kdePackages.okular
        ghostscript
        # FIXME: force to use x11 since there is opentabletdiver issues with wayland
        (unstable.obsidian.override { commandLineArgs = [ "--ozone-platform=x11" ]; })
      ] else [ ]) ++

      (if cfg.office.enable then [
        libreoffice-fresh # Sometimes I need edit MS-office documents
        hunspell # Spell checker
        hunspellDicts.ru_RU # RU dictionary from LibreOffice
      ] else [ ]);
  };
}