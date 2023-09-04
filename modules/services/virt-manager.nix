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
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [ virt-manager ];
    user.extraGroups = [ "libvirtd" ];

    # Fix Could not detect a default hypervisor. Make sure the appropriate
    # QEMU/KVM virtualization packages are installed to manage virtualization
    # on this host using home-manager.
    home-manager.users.${config.user.name}.dconf.settings."org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
 };
}