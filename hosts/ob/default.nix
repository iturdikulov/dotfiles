{ inputs, pkgs, config, lib, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.asus-rog-strix-g513im
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      hyprland = {
        enable = true;
        monitors = [{
          output = "eDP-1";
          primary = true;
          mode = "1920x1080@300";
          position = "0x0";
          scale = "1.5";
        }];
      };
      high-dpi.scaleFactor = "1.5";
      wine.enable = true;
      appimage.enable = true;
      term = {
        default = "foot";
        foot.enable = true;
      };
      apps = {
        rofi.enable = true;
        slack.enable = true;
        zoom.enable = true;
        thunderbird.enable = true;
        telegram.enable = true;
        godot.enable = true;
        filezilla.enable = true;
        gpt4all.enable = true;
        stellarium.enable = true;
        qucs.enable = true;

        parsec.enable = true;
        remmina.enable = true;
        anydesk.enable = true;
        wireshark.enable = true;
      };
      browsers = {
        default = "firefox";
        brave.enable = true;
        chrome.enable = true;
        firefox.enable = true; # Fallback browser
      };
      gaming = {
        native_games.enable = true;
        steam.enable = true;
        emulators.enable = true;
        tools.enable = true;
      };
      media = {
        archive.enable = true;
        documents.enable = true;
        documents.office.enable = true;
        graphics.enable = true;
        mpv.enable = true;
        kodi.enable = true;
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
      java.enable = true;
      python.pycharm.enable = true;
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
      docs.enable = true; # dev man pages and docsets tools

      fhs-compat.enable = true;
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
      bash.enable = true;
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
      wlsunset.enable = true;

      resilio.enable = true;
      virt-manager.enable = true;

      nginx.enable = true;
      docker.enable = true;
      rabbitmq.enable = false;
      postgresql.enable = false;
      ydotool.enable = true;
      msmtp.enable = true;
    };
    theme.active = "alucard";
  };

  ## GTK bookmarks
  home.configFile."gtk-3.0/bookmarks".text = ''
    file://${config.user.home}/Downloads
    file://${config.user.home}/Arts_and_Entertainment
    file://${config.user.home}/Computer
    file://${config.user.home}/Computer/software
    file://${config.user.home}/Wiki
  '';

  ## Local config
  programs.ssh.startAgent = false;
  services.openssh.startWhenNeeded = true;
  services.pcscd.enable = true; # for gpg-agent
  services.timesyncd.enable = true; # to sync time
  networking.networkmanager.enable = true;
}