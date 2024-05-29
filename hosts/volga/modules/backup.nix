{ options, config, pkgs, lib, ... }:

{
    # BORG
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

            postPrune = ''
              ls -l /archive/backup/file/${name}
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


    # BTRBK
    # services.btrbk = {
    #   instances."kama" = {
    #     onCalendar = "weekly";
    #     settings = {
    #       ssh_user = config.user.name;
    #       ssh_identity = "/etc/btrbk_kama_key"; # NOTE: must be readable by user/group
    #       stream_compress = "lz4";
    #
    #       snapshot_preserve_min = "2d";
    #       snapshot_preserve = "14d";
    #       target_preserve_min = "no"; # use target_preserve config
    #       target_preserve = "1d 4w 12m"; # keep backups daily 1d, weekly 4w, monthly 12m
    #
    #       volume."/" = {
    #         subvolume = "home";
    #         target = "ssh://kama/media/backup/snapshot";
    #       };
    #     };
    #   };
    # };
}