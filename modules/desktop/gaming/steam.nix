{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.steam;
in {
  options.modules.desktop.gaming.steam = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    # better for steam proton games
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";

    user.packages = with pkgs; [
      # require for some games (BeamNG.drive)
      gamemode

      # launch unreal engine (custom compiled)
      (makeDesktopItem {
        name = "unreal-editor";
        desktopName = "Unreal Editor";
        genericName = "Open Unreal Editor";
        icon = "ubinary";
        exec = "${steam-run}/bin/steam-run /games/UnrealEngine/Engine/Binaries/Linux/UnrealEditor %f";
        categories = [ "Graphics" ];
      })
    ];

  };
}