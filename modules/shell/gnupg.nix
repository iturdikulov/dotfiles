{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.gnupg;
    pinentryPkg = pkgs.pinentry-rofi.override {
            rofi = if config.modules.desktop.type == "wayland"
                   then pkgs.rofi-wayland-unwrapped
                   else pkgs.rofi;
    };

    pinentryGUIbin = "${pinentryPkg}/bin/pinentry-rofi";

    # pinentry-auto based on https://superuser.com/a/1761740
    pinentryAuto = pkgs.writeShellScriptBin "pinentry-auto" ''
        #!/bin/sh

        pe=${pinentryGUIbin}  # default
        bin=${pkgs.pinentry-all}/bin
        case "$PINENTRY_USER_DATA" in
        *USE_TTY*)  pe=$bin/pinentry-tty  ;;
        *USE_CURSES*)   pe=$bin/pinentry-curses ;;

        # Uncomment if you won't use pinentry-rofi in that cases
        # *USE_GTK2*) pe=$bin/pinentry-gtk-2 ;;
        # *USE_GNOME3*)   pe=$bin/pinentry-gnome3 ;;
        # *USE_X11*)  pe=$bin/pinentry-x11 ;;
        # *USE_QT*)   pe=$bin/pinentry-qt ;;
        esac
        exec $pe "$@"
    '';

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

    systemd.user.services.gpg-agent.serviceConfig.Environment = [
      "GNUPGHOME=/home/${config.user.name}/.config/gnupg"
    ];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # Don't specify any pinentry flavor in the gpg-agent's service, otherwise
      # it could potentially overwrite our dotfiles.
      pinentryPackage = pinentryPkg;
    };

    user.packages = with pkgs; [
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

    # HACK: Passing GTK2_RC_FILES to the service's Environment didn't work. And
    #   setting GTK2_RC_FILES globally in
    #   services.xserver.displayManager.sessionCommands is too nuclear an
    #   option. This is a clumsy workaround, but is the most targeted.

    home.configFile."gnupg/gpg-agent.conf" = {
      text = ''
        default-cache-ttl ${toString cfg.cacheTTL}
        default-cache-ttl-ssh ${toString cfg.cacheTTL}
        max-cache-ttl     ${toString cfg.maxCacheTTL}
        max-cache-ttl-ssh ${toString cfg.maxCacheTTL}
        allow-loopback-pinentry

        # pinentry-program ${pinentryAuto}/bin/pinentry-auto
      '';
    };
  }

  );
}