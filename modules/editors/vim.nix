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

  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-medium
      supertabular paracol fira
      adjustbox alegreya babel bookcover catchfile chngcntr
      collectbox currfile emptypage enumitem environ fgruler
      fontaxes framed fvextra idxlayout ifmtarg ifnextok
      ifplatform imakeidx import inconsolata l3packages lettrine
      libertine libertinus-fonts listings mdframed microtype
      minifp minted mweights needspace newtx noindentafter
      nowidow subfigure subfiles textpos tcolorbox
      tikz-cd titlecaps titlesec todonotes trimspaces upquote
      xifthen xpatch xstring zref
      pdfjam # manipulating PDF files
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of
      kurier opensans cantarell babel-russian collection-langcyrillic;
      #(setq org-latex-compiler "lualatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
  });

in {
  options.modules.editors.vim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      git
      gnutls              # for TLS connectivity
      fd                  # faster projectile indexing
      tree-sitter         # a parser generator tool and an incremental parsing library

      xkb-switch          # for better keyborad layout switching

      # required for telescope-media-files-nvim
      unstable.chafa
      poppler_utils
      unstable.imagemagick

      ## Module dependencies
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      editorconfig-core-c
      sqlite

      # Vim-Tex dependencies
      tex
      kdePackages.okular

      ## LSP
      lua-language-server
      clang-tools        # NOTE: sync this with cc.nix
      ltex-ls
      nil                # Yet another language server for Nix
      efm-langserver     # for formatting
      unstable.emmet-ls  # HTML/XML/CSS completion
      texlab             # LaTeX
      ruff-lsp           # Python linter
      gopls              # Go
      marksman           # Markdown
      nil                # Nix

      ## Formatting
      stylua
      sqlfluff
      shfmt

      ## Debugging
      vscode-js-debug
      vscode-extensions.vadimcn.vscode-lldb

      # Desktop file
      (makeDesktopItem {
        name = "nvim";
        desktopName = "Neovim Text Editor";
        comment = "Edit text files";
        tryExec = "nvim";
        exec = "${getExe' pkgs.foot "foot"} -e nvim %F";
        terminal = false;
        type = "Application";
        keywords = [ "Text" "editor" ];
        icon = "nvim";
        categories = [ "Utility" "TextEditor" ];
        startupNotify = false;
        mimeTypes = [ "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
      })
    ];

    # Add LLDB debugger path into environment variables
    env.LLDB_VSCODE_DEBUGGER_PATH = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      configure = {
         customRC = ''
           luafile $XDG_CONFIG_HOME/nvim/init.lua
         '';
      };
    };
  };
}