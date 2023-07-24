# When I'm stuck in the terminal or don't have access to Emacs, (neo)vim is my
# go-to. I am a vimmer at heart, after all.

{ config, lib, pkgs, home, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vim;
    configDir = config.dotfiles.configDir;
    fromGitHub = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
      };
    };
in {
  options.modules.editors.vim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
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

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
        configure = {
         customRC = ''
           luafile $XDG_CONFIG_HOME/nvim/init.lua
         '';

         packages.neovimPlugins = with pkgs.vimPlugins; {
           start = [
             plenary-nvim
	     telescope-nvim
             nvim-treesitter.withAllGrammars

	     (fromGitHub "HEAD" "navarasu/onedark.nvim")
	     (fromGitHub "HEAD" "tpope/vim-fugitive")
	   ];
         };
       };

      #plugins = with pkgs.vimPlugins; [
      #  nvim-lspconfig
      #
      #
      #
      #];
    };

    environment.shellAliases = {
      vim = "nvim";
      v   = "nvim";
    };

    # fonts.fonts = [ pkgs.vim-all-the-icons-fonts ];
  };
}
