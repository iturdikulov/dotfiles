# When I'm stuck in the terminal or don't have access to Emacs, (neo)vim is my
# go-to. I am a vimmer at heart, after all.

{ config, lib, pkgs, home, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vim;
    configDir = config.dotfiles.configDir;

    # Looad plugin from github
    # usage (fromGitHub "HEAD" "user/repo")
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

      ## LSP
      lua-language-server
      clang-tools  # NOTE: sync this with cc.nix
      nodePackages.pyright  # NOTE: sync this with python.nix

      # NOTE: sync this with node.nix
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
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
                 harpoon
                 which-key-nvim
                 comment-nvim
                 onedark-nvim

                 # LSP, autocomplete and snippets
                 nvim-lspconfig
                 nvim-cmp
                 cmp-buffer
                 cmp-path
                 cmp-nvim-lsp
                 luasnip
                 cmp_luasnip
                 friendly-snippets
             ];
         };
       };
    };

    environment.shellAliases = {
      vim = "nvim";
      v   = "nvim";
    };

    # fonts.fonts = [ pkgs.vim-all-the-icons-fonts ];
  };
}
