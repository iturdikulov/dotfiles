# When I'm stuck in the terminal or don't have access to Emacs, (neo)vim is my
# go-to. I am a vimmer at heart, after all.

{ config, lib, pkgs, home, inputs, buildNpmPackage
, fetchFromGitHub
, fetchpatch, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vim;
    configDir = config.dotfiles.configDir;

    # Looad plugin from github
    # usage (fromGitHub "HEAD" "user/repo")
    fromGitHub = rev: repo: pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = rev;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        rev = rev;
      };
    };

in {
  options.modules.editors.vim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      vimgolf             # A game that tests Vim efficiency, train vim skills
      git
      gnutls              # for TLS connectivity
      fd                  # faster projectile indexing

      xkb-switch          # for better keyborad layout switching

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
      unstable.emmet-ls
      my.codeium

      ## Formatting
      stylua

      ## Debugging
      vscode-extensions.vadimcn.vscode-lldb
      my.vscode-js-debug

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
      configure = {
         customRC = ''
           luafile $XDG_CONFIG_HOME/nvim/init.lua
         '';
      };
    };

    environment.shellAliases = {
      vim = "nvim";
      v   = "nvim";
    };

    # fonts.packages = [ pkgs.vim-all-the-icons-fonts ];
  };
}