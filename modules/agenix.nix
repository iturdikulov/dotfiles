# modules/agenix.nix -- encrypt secrets in nix store

{ options, config, inputs, lib, pkgs, ... }:

with builtins;
with lib;
with lib.my;
let inherit (inputs) agenix;
    secretsDir = "${toString ../hosts}/${config.networking.hostName}/secrets";
    secretsFile = "${secretsDir}/secrets.nix";

    # TODO: need understand how to use variables here or optimze this?
    # TODO: support only 2 architecures for now
    nix_system = builtins.getEnv "NIX_SYSTEM";
    agenix_package = if nix_system == "aarch64-linux" then agenix.packages.aarch64-linux.default else agenix.packages.x86_64-linux.default;
in {
  imports = [ agenix.nixosModules.default ];
  environment.systemPackages = [ agenix_package ];

  age = {
    secrets =
      if pathExists secretsFile
      then mapAttrs' (n: _: nameValuePair (removeSuffix ".age" n) {
        file = "${secretsDir}/${n}";
        owner = mkDefault config.user.name;
      }) (import secretsFile)
      else {};
    identityPaths =
      options.age.identityPaths.default ++ (filter pathExists [
        "${config.user.home}/.ssh/id_ed25519"
        "${config.user.home}/.ssh/id_rsa"
      ]);
  };
}