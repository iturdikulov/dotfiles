{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
  ];

  ## Modules
  modules = {
    editors = {
      default = "nvim";
      vim.enable = true;
    };
  };
}
