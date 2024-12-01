{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.AI;
in {
  options.modules.shell.AI = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (python3.withPackages (ps: [
        (ps.llm.overridePythonAttrs (old: { doCheck = false; }))
        ps.huggingface-hub
        my.llm-openrouter
        my.files-to-prompt
      ]))
      unstable.koboldcpp
    ];
  };
}