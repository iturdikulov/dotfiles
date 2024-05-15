{ options, config, lib, pkgs, home-manager, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.virt-manager;
    configDir = config.dotfiles.configDir;
in {
  options.modules.services.virt-manager = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;

    # Starts all guests that were running prior to shutdown regardless of their autostart settings.
    virtualisation.libvirtd.onBoot = "start";

    # Enable usb redirection
    virtualisation.spiceUSBRedirection.enable = true;

    # SUPPORT UEFI with qemu
    # CHANGE: use
    #     ls /nix/store/*OVMF*/FV/OVMF{,_VARS}.fd | tail -n2 | tr '\n' : | sed -e 's/:$//'
    # to find your nix store paths
    # maybe you need also to set nvram (I think when used quemu only config)
    # nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]

    virtualisation.libvirtd.qemu.verbatimConfig = ''
      nographics_allow_host_audio = 1
      user = "${config.user.name}"
      group = "libvirtd"
    '';

    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      virt-manager
      virtiofsd
      looking-glass-client
      scream
    ];
    user.extraGroups = [ "libvirtd" ];

    # Fix Could not detect a default hypervisor. Make sure the appropriate
    # QEMU/KVM virtualization packages are installed to manage virtualization
    # on this host using home-manager.
    home-manager.users.${config.user.name}.dconf.settings."org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

    # Looking glass client config file
    home.configFile."looking-glass/client.ini".source = "${configDir}/looking-glass/client.ini";

    # shmem files
    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 inom libvirtd -"
    ];
 };
}