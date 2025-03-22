{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.AI;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.AI = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      my.tungsten              # Wolfram Alpha CLI
      ollama-rocm
      (python3.withPackages (ps: [
        (ps.llm.overridePythonAttrs (old: { doCheck = false; }))
        ps.huggingface-hub
        my.llm-openrouter
        my.files-to-prompt
      ]))
    ];

    modules.shell.zsh.rcFiles = [ "${configDir}/AI/aliases.zsh" ];

    # OPENAI_API_KEY
    system.activationScripts."openai_api_key" = ''
      ${pkgs.coreutils-full}/bin/cat "${config.age.secrets.openai_api_key.path}" > ${config.user.home}/.secrets/openai_api_key
    '';

    modules.shell.zsh.rcInit = ''
      source ${config.user.home}/.secrets/openai_api_key
    '';
  };
}