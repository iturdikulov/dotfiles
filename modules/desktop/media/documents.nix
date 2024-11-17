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
    research.enable = mkBoolOpt true;
    ebook.enable = mkBoolOpt true;
    office.enable = mkBoolOpt false;
  };


  config = mkIf cfg.enable {
    # Config files
    # TODO parametrize this, with mkMerge
    home.configFile."zathura/zathurarc".source = "${configDir}/zathura/zathurarc";

    # Fix foliate xdg-open integration (blank page when open file)
    # FIXME: is this still relevant?
    env.WEBKIT_DISABLE_DMABUF_RENDERER = "1";

    # TODO thing about dotfiles for this packages
    env.CALIBRE_USE_SYSTEM_THEME = "true";
    user.packages = with pkgs;
      (if cfg.ebook.enable then [
        xchm
        calibre
        zathura
        pandoc
      ] else []) ++

      (if cfg.pdf.enable then [
        zathura
        foliate
        ghostscript
        xournalpp
      ] else [ ]) ++

      (if cfg.research.enable then [
        unstable.obsidian # render markdown and learn flashcards
        papis # to store DOI stuff
        wiki-tui # wikipedia in terminal
      ] else [ ]) ++

      (if cfg.office.enable then [
        libreoffice-fresh # Sometimes I need edit MS-office documents
        hunspell # Spell checker
        hunspellDicts.ru_RU # RU dictionary from LibreOffice
      ] else [ ]);
  };
}