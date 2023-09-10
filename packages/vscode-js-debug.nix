{ lib, stdenv, luajit, pkgs, my, ... }:

let name = "js-debug";
    version = "v1.82.0";
    nodeDependencies = (pkgs.callPackage ./js-debug { }).nodeDependencies.overrideAttrs (previousAttrs: {
        buildInputs = with pkgs; previousAttrs.buildInputs ++ [
        nodePackages.node-gyp-build
        nodePackages.node-gyp
        pkg-config
        libsecret
        ];
        });

in stdenv.mkDerivation {
    inherit name version;

    src = pkgs.fetchFromGitHub {
      owner = "microsoft";
      repo = "vscode-js-debug";
      rev = "43ab1c29d3672131d9daa910bd51fefc197f8ac9";
      sha256 = "sha256-EQLNhbvDwYBOsKUDIqWSRzgzmTgRopG/WR3o5+/6Xgo=";
    };

    buildInputs = [ pkgs.nodejs ];

    installPhase =
      let nodeEscaped = builtins.replaceStrings [ "/" "-" "." ] [ "\\/" "\\-" "\\." ] pkgs.nodejs.outPath;
      in
      ''
        mkdir -p $out/bin
        ln -s ${nodeDependencies}/lib/node_modules ./node_modules
        ln -s ${nodeDependencies}/lib/node_modules $out/node_modules
        ./node_modules/.bin/gulp
        ./node_modules/.bin/gulp vsDebugServerBundle:webpack-bundle

        cp -r ./dist $out/dist

        # Add shebang...
        # Wrapping vsDebugServer.js in a sh script doesn't work because it needs to read from
        # a pipe directly from the parent (debugproxy)
        printf "#!${nodeEscaped}\/bin\/node\n" | cat - $out/dist/src/vsDebugServer.js > $out/dist/src/dap-node

        chmod u+x $out/dist/src/dap-node
        ln -s $out/dist/src/dap-node $out/bin/dap-node
      '';
  meta = {
    homepage = "https://github.com/microsoft/vscode-js-debug";
    description = "The VS Code JavaScript debugger ";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [];
  };
}