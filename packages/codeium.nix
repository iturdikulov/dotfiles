{ lib, stdenv, autoPatchelfHook, pkgs, my, ... }:

let name = "codeium";
    version = "1.6.7";
    hash = "sha256-tnhfo84pUiiptPvyP0NKXkSiETedH7An1NAqbwI5Wvg=";
    system = "linux_x64";

in stdenv.mkDerivation {
    inherit name version;

    src = pkgs.fetchurl {
      url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${version}/language_server_${system}";
      sha256 = hash;
    };

    sourceRoot = ".";

    phases = ["installPhase" "fixupPhase"];
    nativeBuildInputs =
      [
      stdenv.cc.cc
      ]
      ++ (
          if !stdenv.isDarwin
          then [autoPatchelfHook]
          else []
         );

    installPhase = ''
      mkdir -p $out/bin
      install -m755 $src $out/bin/codeium-lsp
      '';

    meta = {
      homepage = "https://github.com/Exafunction/codeium";
      description = "Codeium language server";
      license = "Codeium Terms of Service";
      platforms = [ "x86_64-linux" ];
      maintainers = [];
  };
}