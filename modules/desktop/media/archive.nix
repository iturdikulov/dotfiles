# I use archive for my music needs. Gone are the days where I'd manage 200gb+ of
# local music; most of which I haven't heard or don't even like.

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.archive;
in {
  options.modules.desktop.media.archive = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      xarchiver
      p7zip   # A new p7zip fork with additional codecs and improvements
      zstd    # real-time compression algorithm
      brotli  # generic-purpose lossless compression algorithm
      patool  # cli, portable archive file manager
    ];
  };
}
