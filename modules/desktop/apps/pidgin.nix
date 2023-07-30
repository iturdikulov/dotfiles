{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.pidgin;
in {
  options.modules.desktop.apps.pidgin = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (self: super: {
        purple-discord = super.pidginPackages.purple-discord.overrideAttrs (old: {
           version = "unstable-2023-02-15";
           buildInputs = old.buildInputs ++ [ pkgs.qrencode pkgs.nss ];
           src = pkgs.fetchFromGitHub {
             owner = "EionRobb";
             repo = "purple-discord";
             rev = "4a091883e646f2c103ae68c41d04b1b880e8d0bf";
             sha256 = "sha256-MsC2efTvjDOsrs2XZ0kPAKgBLIdTd3Zbm6h9vWuFK6M=";
           };
        });
      })
    ];

    user.packages = with pkgs; [
      (unstable.pidgin.override {plugins = [
        purple-discord
        purple-lurch
        pidgin-window-merge
      ];})
    ];
  };
}
