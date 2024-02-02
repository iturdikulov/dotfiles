{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      dwm.enable = true;
      apps = {
        rofi.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
      };
      gaming = {
        emulators.enable = true;
      };
      media = {
        archive.enable = true;
        documents.enable = true;
      };
      term = {
        default = "xst";
        st.enable = true;
      };
    };
    dev = {
      python.enable = true;
      # node.enable = true;
      # cc.enable = true;
    };
    editors = {
      default = "nvim";
      vim.enable = true;
    };
    shell = {
      network.enable = true;
      files.enable    = true;  # files utilites
      editorconfig.enable = true;

      gnupg = {
        enable = true;
      };

      direnv.enable = true;
      git.enable    = true;
      tmux.enable   = true;
      zsh.enable    = true;
    };
    services = {
      dictd.enable = true;
      ssh.enable = true;
      docker.enable = true;
      syncthing.enable = true;
      nginx.enable = true;
      miniflux.enable = true;
      gitea.enable = true;
      calibre.enable = true;
      tailscale.enable = true;
      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "alucard";
  };

  ## btrbk required config
  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "${pkgs.coreutils-full}/bin/test";
          options = [ "NOPASSWD" ];
        }
        # In some reason required to add full path
        # in config example this wasn't required
        # I THINK BECAUSE USED SAME USER inom, need change config
        # to use btrbk user
        # TODO: maybe need to check/remove this
        {
          command = "/run/current-system/sw/bin/test";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.coreutils-full}/bin/readlink";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/readlink";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.btrfs-progs}/bin/btrfs";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/btrfs";
          options = [ "NOPASSWD" ];
        }
      ];
      groups = [ "wheel" ];
    }];
    extraConfig = with pkgs; ''
      Defaults:picloud secure_path="${lib.makeBinPath [
        btrfs-progs coreutils-full
      ]}:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
    '';
  };
  environment.systemPackages = [ pkgs.lz4 ];

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