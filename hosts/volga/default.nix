{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
    ./modules/dyndns.nix
  ];

  ## Modules
  modules = {
    desktop = {
      dwm.enable = true;
      apps = {
        rofi.enable = true;
        godot.enable = true;
        slack.enable = true;
        thunderbird.enable = true;
        telegram.enable = true;
        pidgin.enable = true;
      };
      browsers = {
        default = "firefox";
        brave.enable = true;
        firefox.enable = true;
        qutebrowser.enable = true;
      };
      gaming = {
        steam.enable = true;
        # emulators.enable = true;
        # emulators.psx.enable = true;
        native_games.enable = true;
      };
      media = {
        archive.enable = true;
        daw.enable = true;
        documents.enable = true;
        documents.office.enable = true;
        graphics.enable = true;
        mpv.enable = true;
        recording.enable = true;
        spotify.enable = true;
        espeak.enable = true;
        useless.enable = true;
      };
      term = {
        default = "xst";
        st.enable = true;
      };
      vm = {
        qemu.enable = true;
      };
    };
    dev = {
      node.enable = true;
      rust.enable = true;
      python.enable = true;
      cc.enable = true;
      lua.enable = true;
      lua.love2D.enable = true;
      haxe.enable = true;
    };
    editors = {
      default = "nvim";
      emacs.enable = false;
      vim.enable = true;
    };
    shell = {
      network.enable = true;
      db.enable       = true;  # database CLI's
      files.enable    = true;  # files utilites

      AI.enable       = true;  # ChatGPT, wolfram-alpha

      editorconfig.enable = true;

      gnupg = {
        enable = true;
      };

      pass.enable   = true;

      ddgr.enable     = true;
      w3m.enable    = true;
      xh.enable     = true;
      ytfzf.enable  = true;
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
      termdown.enable    = true;
      vaultwarden.enable = false;
    };
    services = {
      dictd.enable = true;
      ssh.enable = true;
      docker.enable = true;
      syncthing.enable = true;
      virt-manager.enable = true;
      nginx.enable = true;
      calibre.enable = true;

      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "alucard";
  };


  ## Local config
  programs.ssh.startAgent = false;
  services.openssh.startWhenNeeded = true;
  services.openssh.settings.X11Forwarding = true;
  services.pcscd.enable = true;     # for gpg-agent
  services.timesyncd.enable = true; # to sync time

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