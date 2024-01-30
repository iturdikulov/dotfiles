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
      dwarf-fortress # Not really useless ;-) A single-player fantasy game
      superTuxKart   # A Free 3D kart racing game
      superTux       # Classic 2D jump'n run sidescroller game
      openmw         # An unofficial open source engine reimplementation of the game Morrowind
      mari0          # Crossover between Super Mario Bros. and Portal
      colobot        # Gold Edition is a real-time strategy game, where you can program your bots
    ];
  };
}