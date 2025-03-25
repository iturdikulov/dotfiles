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
            # Mounted dirs
            "Media/"
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
              # TODO remove /README postfix to sync all repo
              ${pkgs.rclone}/bin/rclone sync -v --config ${config.user.home}/.config/rclone/rclone.conf \
              --bwlimit 2M  --max-duration 9h \
              /archive/backup/file/${name} repo:${name}

              # TODO weekly borg and rsync verify script
              ls -l /archive/backup/file/${name}
            '';
          };
    in {
      home-inom = basicBorgJob config.user.name // rec {
        paths = config.user.home;
        exclude = map (x: paths + "/" + x) common-excludes;
      };
    };

    # Notify on backup failures
    systemd.services = {
      "notify-problems@" = {
        enable = true;
        script = ''
          ${pkgs.system-sendmail}/bin/sendmail -t <<ERRMAIL
          To: inom@iturdikulov.com
          Subject: Backup failed at $(date)
          From: inom@iturdikulov.com

          Borg backup job failed, here is borg log

          $(systemctl status --full "borgbackup-job-home-${config.user.name}.service")
          ERRMAIL
        '';
      };
    } // lib.flip lib.mapAttrs' config.services.borgbackup.jobs (name: value:
      lib.nameValuePair "borgbackup-job-${name}" {
        unitConfig.OnFailure = "notify-problems@%i.service";
      }
    );
}