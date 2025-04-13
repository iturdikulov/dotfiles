{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
    ./modules/adguard.nix
    ./modules/gitea.nix
    ./modules/taskwarrior.nix
    ./modules/autologin.nix
    ./modules/smb.nix
    ./modules/proxy.nix
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
      maintenance.enable = true;

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
      qbittorrent ={
        enable = true;
        profile = "/media/qbittorrent";
      };
      virt-manager.enable = true;

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