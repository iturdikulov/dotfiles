{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.editorconfig;
in {
  options.modules.shell.editorconfig = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.file.".editorconfig" = {
      text = ''
# EditorConfig configuration
# https://EditorConfig.org
# original file: https://github.com/NixOS/nixpkgs/blob/master/.editorconfig

# Top-most EditorConfig file
root = true

# Unix-style newlines with a newline ending every file, utf-8 charset
[*]
charset = utf-8
end_of_line = lf
indent_size = 4
indent_style = space
insert_final_newline = true
trim_trailing_whitespace = true
max_line_length = 80

[*.py]
quote_type = double

# Web files
[*.{js,json,yml,html,md,css,scss,less,Gemfile}]
indent_style = space
indent_size = 2

# Makefiles
[{Makefile,**.mk}]
indent_style = tab

# Although Markdown/CommonMark allows using two trailing spaces to denote
# a hard line break, I do not use that feature since
# it forces the surrounding paragraph to become a <literallayout> which
# does not wrap reasonably.
# Instead of a hard line break, start a new paragraph by inserting a blank line.
[*.md]
trim_trailing_whitespace = false

# Ignore diffs/patches
[*.{diff,patch}]
end_of_line = unset
insert_final_newline = unset
trim_trailing_whitespace = unset

# Ignore c/headers, some of them can have own indentation style
# we use auto-detection for these
[*.{c,h}]
insert_final_newline = unset
trim_trailing_whitespace = unset

# Same for confi/encrypted files/etc.
[*.{asc,key,ovpn,cfg,config,lock}]
insert_final_newline = unset
end_of_line = unset
trim_trailing_whitespace = unset

# Binaries
[*.nib]
end_of_line = unset
insert_final_newline = unset
trim_trailing_whitespace = unset
charset = unset

[eggs.nix]
trim_trailing_whitespace = unset
    '';
    };
  };
}