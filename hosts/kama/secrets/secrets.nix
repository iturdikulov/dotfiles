let key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZ+98UauMXllELyhSNhTTJPITI2OmJSNf1HUXxjiv6V inom@iturdikulov.org";
in {
  "singbox_vless_server.age".publicKeys = [key];
  "singbox_vless_uuid.age".publicKeys = [key];
  "singbox_vless_public_key.age".publicKeys = [key];
  "singbox_vless_short_id.age".publicKeys = [key];
}