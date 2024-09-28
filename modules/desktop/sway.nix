{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.sway;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.sway = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      # mako # notification system developed by swaywm maintainer
      pulseaudio # for volume control
      foot
      bemenu
    ];

    # # Enable the gnome-keyring secrets vault.
    # # Will be exposed through DBus to programs willing to store secrets.
    # services.gnome.gnome-keyring.enable = true;

    services = {
      gvfs.enable = true;
    };

    # enable Sway window manager
    programs.sway = {
      enable = true;
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
      '';
      wrapperFeatures.gtk = true;
    };

     services.greetd = {
        enable = true;
        settings = rec {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd sway";
            user = "greeter";
          };
        };
      };

    home.configFile."sway/config".text = ''
      output * scale 1.5

      set $mod Mod4
      set $menu bemenu-run | wmenu | xargs swaymsg exec --

      set $term foot

      # Start a terminal
      bindsym $mod+Return exec $term

      # Kill focused window
      bindsym $mod+Shift+q kill

      # Start your launcher
      bindsym $mod+d exec $menu

      # Brightness
      bindsym XF86MonBrightnessDown exec light -U 10
      bindsym XF86MonBrightnessUp exec light -A 10

      # Volume
      bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
      bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
      bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'

      input type:keyboard {
          xkb_layout "us,ru"
          xkb_options "grp:menu_toggle,lv5:ralt_switch,compose:rwin"
          xkb_variant "colemak_dh,"
      }
    '';

    # Enable brightness and volume
    user.extraGroups = [ "video" ];
    programs.light.enable = true;
  };
}