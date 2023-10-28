# modules/desktop/media/docs.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.documents;
    configDir = config.dotfiles.configDir;
in {
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
    home.configFile."sioyek/keys_user.config".source = "${configDir}/sioyek/keys_user.config";

    # TODO thing about dotfiles for this packages
    user.packages = with pkgs;
      (if cfg.ebook.enable then [
        xchm
        sioyek
        zathura
        pandoc
        calibre
        foliate
      ] else [])++

      (if cfg.pdf.enable then [
        zathura
        ghostscript
      ] else [])++

      (if cfg.research.enable then [
        unstable.obsidian # render markdown and learn flashcards
        papis # to store DOI stuff
        wiki-tui # wikipedia in terminal
        taskwarrior # my daily tasks
        taskwarrior-tui # TUI to rare clean taskwarrior tasks
      ] else [])++

      (if cfg.office.enable then [
        libreoffice-fresh  # Sometimes I need edit MS-office documents
        hunspell  # Spell checker
        hunspellDicts.ru_RU  # RU dictionary from LibreOffice
      ] else []);
  };
}