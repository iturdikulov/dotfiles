# modules/dev/node.nix --- https://nodejs.org/en/
#
# JS is one of those "when it's good, it's alright, when it's bad, it's a
# disaster" languages.

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.node;
    configDir = config.dotfiles.configDir;
    nodePkg = pkgs.nodejs_latest;
in {
  options.modules.dev.node = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
     (mkIf cfg.enable {
      user.packages = with pkgs; [
        nodePkg
        nodePackages.typescript
        nodePackages.ts-node
        nodePackages.node2nix
        nodePackages.browser-sync
        yarn
        bun
        mockoon

        # LSP
        nodePackages.typescript-language-server
        nodePackages.vscode-langservers-extracted

        # Analysis
        nodePackages.eslint_d  # Statically analyzes JS to find problems
      ];

      # Run locally installed bin-script, e.g. n coffee file.coffee
      environment.shellAliases = {
        n  = "PATH=\"$(${nodePkg}/bin/npm bin):$PATH\"";
        ya = "yarn";
      };

      env.PATH = [ "$(${pkgs.yarn}/bin/yarn global bin)" ];

      # Prettierrc config
      home.file.".prettierrc".source = "${configDir}/prettier/.prettierrc";
    })

    (mkIf cfg.xdg.enable {
      # NPM refuses to adopt XDG conventions upstream, so I enforce it myself.
      env.NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/config";
      env.NPM_CONFIG_CACHE      = "$XDG_CACHE_HOME/npm";
      env.NPM_CONFIG_TMP        = "$XDG_RUNTIME_DIR/npm";
      env.NPM_CONFIG_PREFIX     = "$XDG_CACHE_HOME/npm";
      env.NODE_REPL_HISTORY     = "$XDG_CACHE_HOME/node/repl_history";

      home.configFile."npm/config".text = ''
        cache=$XDG_CACHE_HOME/npm
        prefix=$XDG_DATA_HOME/npm
      '';
    })
  ];
}