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
    ebook.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs;
      (if cfg.ebook.enable then [
	calibre
      ] else [])++

      (if cfg.pdf.enable then [
	zathura
      ] else [])++

      (if cfg.research.enable then [
        papis # to store DOI stuff
	obsidian # render markdown and learn flashcards
      ] else []);

    # TODO thing about dotfiles for this packages
  };
}
