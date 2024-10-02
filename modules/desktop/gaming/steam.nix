{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.steam;
    steamDir = "$XDG_STATE_HOME/steam";
in {
  options.modules.desktop.gaming.steam = with types; {
    enable = mkBoolOpt false;
    mangohud.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
      };

      # SteamOS session compositing window manager
      # Steam > Game > Properties > Launch Options and add:
      # run with resolution & fps & fullscreen & mangohud
      # gamescope -W 3840 -H 2160 -r 60 -f -e -- mangohud gamemoderun %command%
      # Options:
      #   -W, --output-width             output width
      #   -H, --output-height            output height
      #   -r, --nested-refresh           game refresh rate (frames per second)
      #   -e, --steam                    enable Steam integration
      #   -f, --fullscreen               make the window fullscreen
      gamescope.enable = true;

      gamemode = {
        enable = true;
        settings = {
          general = {
            inhibit_screensaver = 0;
            renice = 10;
          };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
        };
      };
    };

    user.extraGroups = [ "gamemode" ];

    # Stop Steam from polluting $HOME
    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "steam" ''
        mkdir -p "${steamDir}"
        HOME="${steamDir}" exec ${config.programs.steam.package}/bin/steam "$@"
      '')
      # for running GOG and humble bundle games
      (writeShellScriptBin "steam-run" ''
        mkdir -p "${steamDir}"
        HOME="${steamDir}" exec ${config.programs.steam.package.run}/bin/steam-run "$@"
      '')
    ] ++ (if cfg.mangohud.enable then [ pkgs.mangohud ] else []);

    # Better for steam proton games
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";
  };
}