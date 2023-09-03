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
      dasht               # to search in docsets

      # required for telescope-media-files-nvim
      chafa
      poppler_utils
      imagemagick

      ## Module dependencies
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      editorconfig-core-c
      sqlite
      texlive.combined.scheme-medium

      ## LSP
      lua-language-server
      clang-tools  # NOTE: sync this with cc.nix
      ltex-ls
      nil             # Yet another language server for Nix
      efm-langserver  # for formatting

      ## Formatting
      luaformatter

      ## Debugging
      vscode-extensions.vadimcn.vscode-lldb

      # Desktop file
      (makeDesktopItem {
        name = "nvim";
        desktopName = "Neovim Text Editor";
        comment = "Edit text files";
        tryExec = "nvim";
        exec = "${pkgs.xst}/bin/xst -e nvim %F";
        terminal = false;
        type = "Application";
        keywords = [ "Text" "editor" ];
        icon = "nvim";
        categories = [ "Utility" "TextEditor" ];
        startupNotify = false;
        mimeTypes = [ "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
      })
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      package = pkgs.neovim-unwrapped;
        configure = {
         customRC = ''
           luafile $XDG_CONFIG_HOME/nvim/init.lua
         '';

         packages.neovimPlugins = with pkgs.vimPlugins; {
             start = [
                 plenary-nvim

                 onedark-nvim
                 nvim-web-devicons
                 (fromGitHub "HEAD" "tjdevries/express_line.nvim")

                 telescope-nvim
                 telescope-file-browser-nvim
                 (fromGitHub "HEAD" "renerocksai/telekasten.nvim")

                 (fromGitHub "HEAD" "phelipetls/jsonpath.nvim")
                 vim-fugitive
                 vim-rsi
                 vim-gnupg

                 refactoring-nvim
                 vim-dasht
                 nvim-treesitter.withAllGrammars
                 harpoon
                 which-key-nvim
                 comment-nvim
                 undotree
                 nvim-ufo
                 gitsigns-nvim
                 nvim-surround
                 trouble-nvim

                 popup-nvim
                 telescope-media-files-nvim  # required plenary-nvim, popup.nvim, telescope.nvim

                 sniprun
                 (fromGitHub "HEAD" "antonk52/markdowny.nvim")
                 (fromGitHub "HEAD" "cbochs/portal.nvim")

                 copilot-lua
                 copilot-cmp

                 nvim-dap
                 nvim-dap-ui
                 nvim-dap-virtual-text
                 nvim-dap-python
                 telescope-dap-nvim

                 neotest
                 neotest-rust
                 neotest-python

                 # LSP, autocomplete and snippets
                 nvim-lspconfig
                 nvim-cmp
                 cmp-buffer
                 cmp-path
                 cmp-nvim-lsp
                 luasnip
                 cmp_luasnip
                 friendly-snippets
                 ltex_extra-nvim
                 (fromGitHub "HEAD" "creativenull/efmls-configs-nvim")
             ];
         };
       };
    };

    environment.shellAliases = {
      vim = "nvim";
      v   = "nvim";
    };

    # fonts.packages = [ pkgs.vim-all-the-icons-fonts ];
  };
}