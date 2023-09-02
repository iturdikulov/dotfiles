let key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZ+98UauMXllELyhSNhTTJPITI2OmJSNf1HUXxjiv6V Inom M. Turdikulov inom@iturdikulov.org";
in {
  "sshcontrol.age".publicKeys = [key];
}