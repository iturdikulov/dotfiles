let key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAuq7AMP3tGbkgRpdb0MX4JHT9NeUiif0w8xF00iqjq Inom M. Turdikulov inom@iturdikulov.org";
in {
  "wireguard.age".publicKeys = [key];
}