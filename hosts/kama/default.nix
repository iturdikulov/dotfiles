{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
    ./modules/adguard.nix
    ./modules/calibre.nix
    ./modules/gitea.nix
    ./modules/miniflux.nix
    ./modules/syncthing.nix
    ./modules/photoprism.nix
    ./modules/taskwarrior.nix
    ./modules/jupyenv.nix
    ./modules/autologin.nix
    ./modules/smb.nix
  ];

  ## Modules
  modules = {
    dev = {
      python.enable = true;
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
      nginx.enable = true;
      tailscale.enable = true;
      mysql.enable = true; # for photoprism
      qbittorrent.enable = true;

      spoofdpi.enable = true;
      spoofdpi.openFirewall = true;
      spoofdpi.address = "192.168.0.190";

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