{
  lib,
  coreutils,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "tun2proxy";
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3Ircbo4NEk3UBFfqfSd3NUq9LI9Ll4x2MVskUbkQQjQ=";
  };

  meta = with lib; {
    homepage = "https://github.com/tun2proxy/tun2proxy";
    mainProgram = "tun2proxy";
    platforms = [ "x86_64-linux" ];
    license     = licenses.mit;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
  };
}