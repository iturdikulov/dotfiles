# flake.nix --- the heart of my dotfiles
#
# Author:  Henrik Lissner <contact@henrik.io>
# URL:     https://github.com/hlissner/dotfiles
# License: MIT
#
# Welcome to ground zero. Where the whole flake gets set up and all its modules
# are loaded.

{
  description = "A grossly incandescent nixos config.";

  inputs =
    {
      # Core dependencies.
      nixpkgs.url = "nixpkgs/nixos-unstable";             # primary nixpkgs
      nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";  # for packages on the edge
      home-manager.url = "github:rycee/home-manager/master";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      agenix.url = "github:ryantm/agenix";
      agenix.inputs.nixpkgs.follows = "nixpkgs";

      # TODO: remove this, temporary workaround to avoid launch proble
      dbeaver-last.url = "github:nixos/nixpkgs/4d10225ee46c0ab16332a2450b493e0277d1741a";

      # Extras
      emacs-overlay.url  = "github:nix-community/emacs-overlay";
      nixos-hardware.url = "github:nixos/nixos-hardware";
      rust-overlay.url = "github:oxalica/rust-overlay";
      blender-bin.url = "github:edolstra/nix-warez?dir=blender";
      blender-bin.inputs.nixpkgs.follows = "nixpkgs-unstable";

      wired.url = "github:Toqozz/wired-notify";
      wired.inputs.nixpkgs.follows = "nixpkgs";
    };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, wired, ... }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      nix_system = builtins.getEnv "NIX_SYSTEM";
      system = if nix_system == "" then "x86_64-linux" else nix_system;

      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;  # forgive me Stallman senpai

        # Allos some insecure packages
        # TODO: potentially need remove all this
        config.permittedInsecurePackages = [
          "fspy-1.0.3"
        ];

        overlays = extraOverlays ++ (lib.attrValues self.overlays);
      };
      pkgs  = mkPkgs nixpkgs [ self.overlay ];
      pkgs' = mkPkgs nixpkgs-unstable [];

      lib = nixpkgs.lib.extend
        (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });
    in {
      lib = lib.my;

      overlay =
        final: prev: {
          unstable = pkgs';
          my = self.packages."${system}";
        };


      overlays =
        mapModules ./overlays import;


      packages."${system}" =
        mapModules ./packages (p: pkgs.callPackage p {});

      nixosModules =
        { dotfiles = import ./.; } // mapModulesRec ./modules import;

      nixosConfigurations =
        mapHosts ./hosts {};

      devShell."${system}" =
        import ./shell.nix { inherit pkgs; };

      templates = {
        full = {
          path = ./.;
          description = "A grossly incandescent nixos config";
        };
      } // import ./templates;
      defaultTemplate = self.templates.full;

      defaultApp."${system}" = {
        type = "app";
        program = ./bin/hey;
      };
    };
}