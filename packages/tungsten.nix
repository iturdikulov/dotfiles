{ lib, stdenv, bash, xmlstarlet, makeWrapper, my, ... }:

let name = "tungsten";
    version = "2.1";

in stdenv.mkDerivation {
  inherit name version;

  src = fetchTarball {
    url = "https://github.com/ASzc/${name}/archive/refs/tags/release-${version}.tar.gz";
    sha256 = "sha256:1388bnxxjbfnq7s1101hqcc7yb4iakgzxa75ypmqcdr5x5p75dp9";
  };

  buildInputs = [ bash xmlstarlet ];
  nativeBuildInputs = [ makeWrapper ];

  # need to cd into $out in order for classpath to pick up correct jar files
  installPhase = ''
    install -D $src/tungsten.sh $out/bin/tungsten
    substituteInPlace $out/bin/tungsten \
      --replace /bin/bash '/usr/bin/env bash'
    wrapProgram $out/bin/tungsten \
      --prefix PATH : ${xmlstarlet}/bin
    ln -s $out/bin/tungsten $out/bin/wa
  '';

  meta = {
    homepage = "https://github.com/ASzc/tungsten";
    description = "A WolframAlpha CLI";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [];
  };
}