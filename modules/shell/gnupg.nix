{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.gnupg;
in {
  options.modules.shell.gnupg = with types; {
    enable   = mkBoolOpt false;
    cacheTTL = mkOpt int (3600 * 4);
    maxCacheTTL = mkOpt int (3600 * 24);
    sshKeys = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = ''
          Which GPG keys (by keygrip) to expose as SSH keys.
      '';
    };
  };

  config = mkIf cfg.enable (
  {
    env.GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";

    programs.gnupg.agent.enable = true;
    programs.gnupg.agent.enableSSHSupport = true;
    programs.gnupg.agent.pinentryPackage = pkgs.pinentry-rofi;

    user.packages = with pkgs; [
      tomb      # File encryption on GNU/Linux
      paperkey  # Store OpenPGP or GnuPG on paper
    ];

    # --default-cache-ttl n
    #   Set the time a cache entry is valid to n seconds. The default is 600
    #   seconds. Each time a cache entry is accessed, the entry’s timer is reset.
    #   To set an entry’s maximum lifetime, use max-cache-ttl. Note that a cached
    #   passphrase may not be evicted immediately from memory if no client
    #   requests a cache operation. This is due to an internal housekeeping
    #   function which is only run every few seconds.
    # --max-cache-ttl n
    #   Set the maximum time a cache entry is valid to n seconds. After this time
    #   a cache entry will be expired even if it has been accessed recently or
    #   has been set using gpg-preset-passphrase. The default is 2 hours (7200
    #   seconds).
    home.configFile."gnupg/gpg-agent.conf" = {
      text = ''
        default-cache-ttl ${toString cfg.cacheTTL}
        default-cache-ttl-ssh ${toString cfg.cacheTTL}
        max-cache-ttl     ${toString cfg.maxCacheTTL}
        max-cache-ttl-ssh ${toString cfg.maxCacheTTL}
      '';
    };
  }

  );
}