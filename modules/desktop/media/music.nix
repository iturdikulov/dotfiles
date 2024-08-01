{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.media.music;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.media.music = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      beets

      cmus
      (writeScriptBin "cmus-wr" ''
        #!/bin/sh
        ${pkgs.xst}/bin/xst -n cmus -e ${pkgs.cmus}/bin/cmus "$@"
      '')

      # To mount android devices using gio, trash cli
      glib
      musikcube
      playerctl

      # GUI 🙊
      flacon
      picard
    ];

    # This env mostly used in scripts
    env.AUDIO_PLAYER = "cmus";

    home.configFile."cmus/rc".text = ''
      set color_cmdline_attr=default
      set color_cmdline_bg=233
      set color_cmdline_fg=231
      set color_cur_sel_attr=default
      set color_error=196
      set color_info=81
      set color_separator=47
      set color_statusline_attr=default
      set color_statusline_bg=232
      set color_statusline_fg=34
      set color_titleline_attr=default
      set color_titleline_bg=232
      set color_titleline_fg=83
      set color_trackwin_album_attr=bold
      set color_trackwin_album_bg=default
      set color_trackwin_album_fg=default
      set color_win_attr=default
      set color_win_bg=233
      set color_win_cur=47
      set color_win_cur_attr=default
      set color_win_cur_sel_attr=default
      set color_win_cur_sel_bg=239
      set color_win_cur_sel_fg=47
      set color_win_dir=47
      set color_win_fg=252
      set color_win_inactive_cur_sel_attr=default
      set color_win_inactive_cur_sel_bg=233
      set color_win_inactive_cur_sel_fg=47
      set color_win_inactive_sel_attr=default
      set color_win_inactive_sel_bg=235
      set color_win_inactive_sel_fg=47
      set color_win_sel_attr=default
      set color_win_sel_bg=240
      set color_win_sel_fg=47
      set color_win_title_attr=default
      set color_win_title_bg=232
      set color_win_title_fg=83
      bind -f common delete run trash {}
      update-cache
      add ~/Arts_and_Entertainment/music
    '';
  };
}