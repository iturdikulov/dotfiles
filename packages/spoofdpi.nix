{ pkgs, lib }:

pkgs.buildGoModule {
  pname = "spoofdpi";
  name = "spoofdpi";

  src = pkgs.fetchFromGitHub {
    owner = "xvzc";
    repo = "SpoofDPI";
    rev = "v0.10.0";
    hash = "sha256-e6TPklWp5rvNypnI0VHqOjzZhkYsZcp+jkXUlYxMBlU=";
  };

  vendorHash = "sha256-kmp+8MMV1AHaSvLnvYL17USuv7xa3NnsCyCbqq9TvYE=";

  # No tests included
  doCheck = false;
  ldflags = ["-s" "-w" "-X main.version=v0.10.0" "-X main.builtBy=nixpkgs"];

  meta = with lib; {
    homepage = "https://github.com/xvzc/SpoofDPI";
    description = "A simple and fast anti-censorship tool written in Go";
    license     = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [];
    broken = false;
    mainProgram = "spoof-dpi";
  };
}