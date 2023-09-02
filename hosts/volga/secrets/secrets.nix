let key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZ+98UauMXllELyhSNhTTJPITI2OmJSNf1HUXxjiv6V";
in {
  #"wireguard.age".publicKeys = [key];
  "sshcontrol.age".publicKeys = [key];
}