{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  fetchFromGitHub,
  dpkg,
  glib,
  gnutar,
  gtk3-x11,
  luajit,
  sdcv,
  SDL2,
  zstd,
}:
let
  luajit_lua52 = luajit.override {enable52Compat = true;};
in
  stdenv.mkDerivation rec {
    pname = "koreader";
    version = "2024.07";

    src =
      if stdenv.isAarch64
      then
        fetchurl {
          url = "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-arm64.deb";
          hash = "sha256-KrkY1lTwq8mIomUUCQ9KvfZqinJ74Y86fkPexsFiOPg=";
        }
      else
        fetchurl {
          url = "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-amd64.deb";
          hash = "sha256-Xs9Ci5a3FntRwb6kkn1dCGh62pjj/TF154IG1uiDpRQ=";
        };

    src_repo = fetchFromGitHub {
      repo = "koreader";
      owner = "koreader";
      rev = "v${version}";
      fetchSubmodules = true;
      hash = "sha256-IBGyjw9mzSOBY4GpeHab+aUYh1+Sb0ErfQsc2goO3cM=";
    };

    sourceRoot = ".";
    nativeBuildInputs = [makeWrapper dpkg];
    buildInputs = [
      glib
      gnutar
      gtk3-x11
      luajit_lua52
      sdcv
      SDL2
      zstd.out
    ];
    unpackCmd = "dpkg-deb -x ${src} .";

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -R usr/* $out/
      ln -sf ${luajit_lua52}/bin/luajit $out/lib/koreader/luajit
      ln -sf ${sdcv}/bin/sdcv $out/lib/koreader/sdcv
      ln -sf ${gnutar}/bin/tar $out/lib/koreader/tar
      ln -sf ${zstd.out}/lib/libzstd.so $out/lib/koreader/libs/libzstd.so.1
      find ${src_repo}/resources/fonts -type d -execdir cp -r '{}' $out/lib/koreader/fonts \;
      find $out -xtype l -print -delete
      wrapProgram $out/bin/koreader --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [gtk3-x11 SDL2 glib stdenv.cc.cc.lib]
      }
    '';

    meta = with lib; {
      homepage = "https://github.com/koreader/koreader";
      changelog = "https://github.com/koreader/koreader/releases/tag/v${version}";
      description = "An ebook reader application supporting PDF, DjVu, EPUB, FB2 and many more formats, running on Cervantes, Kindle, Kobo, PocketBook and Android devices";
      mainProgram = "koreader";
      sourceProvenance = with sourceTypes; [binaryNativeCode];
      platforms = ["aarch64-linux" "x86_64-linux"];
      license = licenses.agpl3Only;
      maintainers = with maintainers; [contrun neonfuz];
    };
  }