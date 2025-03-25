{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.steam;
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
      # MANGOHUD_CONFIG=no_display gamescope --mangoapp -W 3840 -H 2160 -r 60 -f -e -- gamemoderun %command%
      # gamescope -F fsr -w 1920 -h 1080 -W 3840 -H 2160 -b -r 60 -f -e -- %command%
      # Options:
      #   -W, --output-width             output width
      #   -H, --output-height            output height
      #
      #   -w, --nested-width             game width
      #   -h, --nested-height            game height
      #   set the resolution used by the game. If -h is specified but
      #   -w isn't, a 16:9 aspect ratio is assumed. Defaults to the
      #   values specified in -W and -H.
      #
      #   -r, --nested-refresh           game refresh rate (frames per second)
      #   -e, --steam                    enable Steam integration
      #   -f, --fullscreen               make the window fullscreen
      #   -b, --borderless               make the window borderless
      #
      #   --mangoapp                     enable mangohud with gamescope

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
    environment.systemPackages = (if cfg.mangohud.enable then [ pkgs.mangohud ] else [ ]);

    # Better for steam proton games
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";
  };
}