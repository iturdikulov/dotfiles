{ options, config, pkgs, lib, ... }:

{
    services.borgbackup.jobs =
      let common-excludes = [
            # Largest cache dirs
            ".cache"
            "*/Cache"
            ".thunderbird/*/calendar-data/cache.sqlite*" # ignore thunderbird cache
            ".config/Slack/logs"
            ".container-diff"
            ".npm/_cacache"
            # Work related dirs
            "*/node_modules"
            "*/_build"
            "*/.tox"
            "*/venv"
            "*/.venv"
          ];
          basicBorgJob = name: {
            encryption.mode = "none";
            extraCreateArgs = "--exclude-caches --verbose --stats --checkpoint-interval 600";
            repo = "/archive/backup/file/${name}";
            compression = "zstd,1";
            startAt = "daily";

            # We can also sync to remote server, TODO: implement, when I have good NAS
            # environment.BORG_RSH = "ssh -o 'StrictHostKeyChecking=no' -i ${config.user.home}/.ssh/...";
            # environment.BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "yes";
            # repo = "ssh://${config.user.name}@kama.home/media/backup/file/${name}";

            # defaults also root, but I set it explicitly
            user = "root";
            group = "root";

            prune.keep = {
              within = "1d"; # Keep all archives from the last day
              daily = 7;
              weekly = 4;
              monthly = 6;
            };

            # TODO: parametrize rclone?
            postPrune = ''
              ${pkgs.rclone}/bin/rclone sync -v --check-first -c --config ${config.user.home}/.config/rclone/rclone.conf \
              --bwlimit 5M \
              /archive/backup/file/${name} repo:${name}
            '';
          };
    in {
      home-inom = basicBorgJob "inom" // rec {
        paths = "/home/inom";
        exclude = map (x: paths + "/" + x) common-excludes;
      };
    };

    # Notify on backup failures
    systemd.services = {
      "notify-problems@" = {
        enable = true;
        serviceConfig.User = "inom";
        environment.SERVICE = "%i";
        script = ''
          # DBUS is optimized for dwm-desktop, you need to tune it for your DE
          export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $USER)/bus
          export DISPLAY=:0
          ${pkgs.libnotify}/bin/notify-send -u critical "$SERVICE FAILED!" "Run journalctl -u $SERVICE for details"
        '';
      };
    } // lib.flip lib.mapAttrs' config.services.borgbackup.jobs (name: value:
      lib.nameValuePair "borgbackup-job-${name}" {
        unitConfig.OnFailure = "notify-problems@%i.service";
      }
    );
}