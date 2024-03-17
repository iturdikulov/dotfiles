{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.native_games;
in {
  options.modules.desktop.gaming.native_games = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      bastet         # Tetris clone with 'bastard' block-choosing AI
      nsnake         # ncurses based snake game for the terminal
      tty-solitaire  # Klondike Solitaire in your ncurses terminal
      moon-buggy     # A simple character graphics game
      nethack        # Rogue-like game
      pokete         # A terminal based Pokemon like game
      mari0          # Crossover between Super Mario Bros. and Portal
      pacvim         # Game that teaches you vim commands
      vimgolf        # A game that tests Vim efficiency, train vim skills
    ];

    # Special wrapper to fix -Z issues
    # TODO: maybe not actual anymore: https://github.com/igrigorik/vimgolf/issues/304
    # remove also vim_golf_fix binary from bin, when it's became not actual
    environment.variables.GOLFVIM = "vim_golf_fix";
  };
}