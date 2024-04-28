let key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZ+98UauMXllELyhSNhTTJPITI2OmJSNf1HUXxjiv6V inom@iturdikulov.org";
in {
  "photoprism.age".publicKeys = [key];
  "jupyenv.age".publicKeys = [key];
}