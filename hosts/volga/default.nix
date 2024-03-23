{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
    ./modules/backup.nix
    ./modules/smb.nix
  ];

  ## Modules
  modules = {
    desktop = {
      dwm.enable = true;
      wine.enable = true;
      term = {
        default = "wezterm";
        wezterm.enable = true;
      };
      apps = {
        rofi.enable = true;
        slack.enable = true;
        thunderbird.enable = true;
        telegram.enable = true;
        ripcord.enable = true;
        pidgin.enable = true;
        godot.enable = true;
        imhex.enable = true;
      };
      browsers = {
        default = "firefox";
        brave.enable = true;
        firefox.enable = true;
        qutebrowser.enable = true;
      };
      gaming = {
        parsec.enable = true;
        native_games.enable = true;
        steam.enable = true;
        emulators.enable = true;
      };
      media = {
        archive.enable = true;
        daw.enable = true;
        documents.enable = true;
        documents.office.enable = true;
        graphics.enable = true;
        mpv.enable = true;
        recording.enable = true;
        espeak.enable = true;
        useless.enable = true;
      };
      };
      vm = {
        qemu.enable = true;
      };
    };
    dev = {
      formatters.enable = true;
      node.enable = true;
      rust.enable = true;
      go.enable = true;
      android.enable = true;
      python.enable = true;
      cc.enable = true;
      lua.enable = true;
      lua.love2D.enable = true;

      clojure.enable = true;
      haxe.enable = true;
      nasm.enable = true;
      r.enable = true;
      scala.enable = true;
      pascal.enable = true;
      common-lisp.enable = true;
      php.enable = true;

      dbeaver.enable = true;
      mitmproxy.enable = true;
      shell.enable = true;
      docs.enable  = true;  # dev man pages and docsets tools (zeal, dasht)
    };
    editors = {
      default = "nvim";
      vim.enable = true;
    };
    shell = {
      network.enable = true;
      db.enable       = true;  # database CLI's
      files.enable    = true;  # files utilites

      AI.enable       = true;  # ChatGPT, wolfram-alpha
      translate-shell.enable = true; # multilingual neural machine translation CLI

      editorconfig.enable = true;

      gnupg = {
        enable = true;
      };

      pass.enable   = true;

      ddgr.enable     = true;
      w3m.enable    = true;
      xh.enable     = true;
      ytfzf.enable  = true;
      yewtube.enable  = true;
      newsboat.enable  = true;

      adl.enable    = true;
      direnv.enable = true;
      git.enable    = true;
      tmux.enable   = true;
      zsh.enable    = true;
      sdcv.enable   = true;
      sc-im.enable  = true;
      weechat.enable     = true;
      maintenance.enable = true;
      timer.enable       = true;
      vaultwarden.enable = false;

      leetcode-cli.enable = true;
    };
    services = {
      dictd.enable = false;
      ssh.enable = true;
      docker.enable = true;
      syncthing.enable = true;
      virt-manager.enable = true;
      nginx.enable = true;
      calibre.enable = true;
      rustdesk.enable = false;
      tailscale.enable = true;

      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "alucard";
  };

  ## Local config
  programs.ssh.startAgent = false;
  services.openssh.startWhenNeeded = true;
  services.pcscd.enable = true;     # for gpg-agent
  services.timesyncd.enable = true; # to sync time

  #services.openssh.settings.X11Forwarding = true;
  ## Taskwarrior config
  # networking.firewall.allowedTCPPorts = [ 53589 ];
  # services.taskserver = {
  #   enable = true;
  #   trust = "allow all";
  #   listenHost = "192.168.0.103";
  #   fqdn = "192.168.0.103";
  #   organisations.home.users = [ "${config.user.name}" ];
  # };

  networking.networkmanager.enable = true;
}