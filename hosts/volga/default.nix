{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
    ./modules/backup.nix
    ./modules/smb.nix
    ./modules/iturdikulov.nix
  ];

  ## Modules
  modules = {
    desktop = {
      high-dpi.enable = true;
      dwm.enable = true;
      wired.enable = true;
      wine.enable = true;
      appimage.enable = true;
      term = {
        default = "xst";
        wezterm.enable = true;
        st.enable = true;
      };
      apps = {
        rofi.enable = true;
        slack.enable = true;
        zoom.enable = true;
        thunderbird.enable = true;
        telegram.enable = true;
        godot.enable = true;
        filezilla.enable = true;
        stellarium.enable = true;

        parsec.enable = true;
        remmina.enable = true;
      };
      browsers = {
        default = "brave";
        brave.enable = true;
        firefox.enable = true; # Fallback browser
      };
      gaming = {
        native_games.enable = true;
        steam.enable = true;
        emulators.enable = true;
      };
      media = {
        archive.enable = true;
        documents.enable = true;
        documents.office.enable = true;
        graphics.enable = true;
        mpv.enable = true;
        recording.enable = true;
        espeak.enable = true;
        useless.enable = true;
        music.enable = true;
      };
      vm = {
        qemu.enable = true;
      };
    };
    dev = {
      formatters.enable = true;
      analysis.enable = true;

      node.enable = true;
      rust.enable = true;
      go.enable = true;
      python.enable = true;
      cc.enable = true;
      lua.enable = true;

      nasm.enable = true;
      pascal.enable = true;
      common-lisp.enable = true;
      php.enable = true;

      dbeaver.enable = true;
      mitmproxy.enable = true;
      shell.enable = true;
      data_serialization.enable = true;
      docs.enable = true; # dev man pages and docsets tools (zeal, dasht)
    };
    editors = {
      default = "nvim";
      vim.enable = true;
    };
    shell = {
      network.enable = true;
      db.enable = true; # database CLI's
      files.enable = true; # files utilites

      AI.enable = true; # ChatGPT, wolfram-alpha
      crow-translate.enable = true; # multilingual neural machine translation GUI/CLI

      editorconfig.enable = true;

      gnupg = {
        enable = true;
      };

      pass.enable = true;

      ddgr.enable = true;
      w3m.enable = true;
      xh.enable = true;
      yewtube.enable = true;
      newsboat.enable = true;
      ttyper.enable = true;

      adl.enable = true;
      direnv.enable = true;
      git.enable = true;
      tmux.enable = true;
      zsh.enable = true;
      sdcv.enable = true;
      visidata.enable = true;
      maintenance.enable = true;
      timer.enable = true;
      vaultwarden.enable = false;

      leetcode-cli.enable = true;
      task.enable = true;
    };
    services = {
      ssh.enable = true;
      docker.enable = true;
      syncthing.enable = true;
      virt-manager.enable = true;
      nginx.enable = true;
      calibre.enable = true;
      tailscale.enable = true;
      tailscale.routingFeatures = "client";

      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "alucard";
  };

  ## GTK bookmarks
  home.configFile."gtk-3.0/bookmarks".text = ''
    file://${config.user.home}/Downloads
    file://${config.user.home}/Work
    file://${config.user.home}/Arts_and_Entertainment
    file://${config.user.home}/Computer
    file://${config.user.home}/Documents
    file://${config.user.home}/Pictures
    file://${config.user.home}/Reference
    file://${config.user.home}/Wiki
  '';

  ## Local config
  programs.ssh.startAgent = false;
  services.openssh.startWhenNeeded = true;
  services.pcscd.enable = true; # for gpg-agent
  services.timesyncd.enable = true; # to sync time

  #services.openssh.settings.X11Forwarding = true;

  networking.networkmanager.enable = true;
}