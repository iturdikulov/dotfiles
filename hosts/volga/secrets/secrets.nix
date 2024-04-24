let key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZ+98UauMXllELyhSNhTTJPITI2OmJSNf1HUXxjiv6V inom@iturdikulov.org";
in {
  "dns-env.age".publicKeys = [key];
  "upsmon.age".publicKeys = [key];
  "samba.age".publicKeys = [key];
}