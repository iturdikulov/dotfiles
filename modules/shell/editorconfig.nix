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
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
charset = utf-8

# Ignore diffs/patches
[*.{diff,patch}]
end_of_line = unset
insert_final_newline = unset
trim_trailing_whitespace = unset

# Match json/lockfiles/markdown/nix/perl/python/ruby/shell/docbook files, set indent to spaces
[*.{json,lock,md,nix,pl,pm,py,rb,sh,xml}]
indent_style = space

# Match docbook files, set indent width of one
[*.xml]
indent_size = 1

# Match json/lockfiles/markdown/nix/ruby files, set indent width of two
[*.{json,lock,nix,rb}]
indent_size = 4

# Match perl/python/shell scripts, set indent width of four
[*.{pl,pm,py,sh}]
indent_size = 4

# Match gemfiles, set indent to spaces with width of two
[Gemfile]
indent_size = 2
indent_style = space

# Disable file types or individual files
# some of these files may be auto-generated and/or require significant changes

[*.{c,h}]
insert_final_newline = unset
trim_trailing_whitespace = unset

[*.{asc,key,ovpn}]
insert_final_newline = unset
end_of_line = unset
trim_trailing_whitespace = unset

[*.lock]
indent_size = unset

# Although Markdown/CommonMark allows using two trailing spaces to denote
# a hard line break, I do not use that feature since
# it forces the surrounding paragraph to become a <literallayout> which
# does not wrap reasonably.
# Instead of a hard line break, start a new paragraph by inserting a blank line.
[*.md]
trim_trailing_whitespace = true
max_line_length = 80

# binaries
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