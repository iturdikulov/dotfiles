# modules/desktop/media/docs.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.documents;
in {
  options.modules.desktop.media.documents = {
    enable = mkBoolOpt false;
    pdf.enable = mkBoolOpt true;
    research.enable = mkBoolOpt true;
    ebook.enable = mkBoolOpt true;
    office.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs;
      (if cfg.ebook.enable then [
        xchm
        zathura
        pandoc
        calibre
      ] else [])++

      (if cfg.pdf.enable then [
        zathura
        ghostscript
      ] else [])++

      (if cfg.research.enable then [
        papis # to store DOI stuff
        obsidian # render markdown and learn flashcards
        wiki-tui # wikipedia in terminal
        taskwarrior # my daily tasks
        taskwarrior-tui # TUI to rare clean taskwarrior tasks
      ] else [])++

      (if cfg.office.enable then [
        libreoffice-fresh  # Sometimes I need edit MS-office documents
        hunspell  # Spell checker
        hunspellDicts.ru_RU  # RU dictionary from LibreOffice
      ] else []);

    # TODO thing about dotfiles for this packages
  };
}