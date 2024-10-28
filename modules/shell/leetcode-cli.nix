# https://github.com/clearloop/leetcode-cli

{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.leetcode-cli;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.leetcode-cli = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      leetcode-cli
    ];

    system.activationScripts."leetcode-cli-secret" = ''
      ${getExe' pkgs.coreutils-full "mkdir"} -p "${config.user.home}/.leetcode"

      CONFIG_FILE="${configDir}/leetcode-cli/leetcode.toml"
      GENERATED_CONFIG_FILE="${config.user.home}/.leetcode/leetcode.toml"
      ${getExe' pkgs.coreutils-full "cat"} "$CONFIG_FILE" > "$GENERATED_CONFIG_FILE"

      COOKIES="${config.age.secrets.leetcode-cli.path}"
      ${getExe' pkgs.coreutils-full "cat"} "$COOKIES" >> "$GENERATED_CONFIG_FILE"
    '';
  };
}