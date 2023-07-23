# When I'm stuck in the terminal or don't have access to Emacs, (neo)vim is my
# go-to. I am a vimmer at heart, after all.

{ config, lib, pkgs, home, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vim;
    configDir = config.dotfiles.configDir;
in {
  options.modules.editors.vim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      neovim

      git
      gnutls              # for TLS connectivity

      fd                  # faster projectile indexing
      imagemagick         # for image-dired

      ## Module dependencies
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      editorconfig-core-c
      sqlite
      texlive.combined.scheme-medium
    ];

    environment.shellAliases = {
      vim = "nvim";
      v   = "nvim";
    };

    # fonts.fonts = [ pkgs.vim-all-the-icons-fonts ];
  };
}
