# modules/dev/cc.nix --- C & C++
#
# I love C. I tolerate C++. I adore C with a few choice C++ features tacked on.
# Liking C/C++ seems to be an unpopular opinion. It's my guilty secret, so don't
# tell anyone pls.

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.cc;
in {
  options.modules.dev.cc = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        gcc
        lld
        gfortran
        llvmPackages.libcxx
        llvmPackages.libcxxStdenv
        llvmPackages.clang
        cling  # Interactive C++ interpreter

        # builder
        gnumake
        cmake
        bear

        # debugger
        lldb
        gdb

        # fix headers not found
        clang-tools

        # other tools
        cppcheck
        libllvm
        valgrind

        # libs
        glm
        SDL2
        SDL2_gfx
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}