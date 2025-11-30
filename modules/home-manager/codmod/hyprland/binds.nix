{
  config,
  lib,
  ...
}:
let
  cfg = config.cm.hyprland;
  mod = "SUPER";
in
{
  wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {
    bind = [
      # Program
      "${mod}, M, exec, hyprctl dispatch exit"
      "${mod}, Q, exec, foot"
      "${mod}, R, exec, bemenu-run"

      # Window
      "${mod} SHIFT, H, movewindow, l"
      "${mod} SHIFT, J, movewindow, d"
      "${mod} SHIFT, K, movewindow, u"
      "${mod} SHIFT, L, movewindow, r"
      "${mod}, C, killactive,"
      "${mod} SHIFT, C, forcekillactive,"
      "${mod} , F, fullscreen,"
      "${mod} SHIFT, 1, movetoworkspace, 1"
      "${mod} SHIFT, 2, movetoworkspace, 2"
      "${mod} SHIFT, 3, movetoworkspace, 3"
      "${mod} SHIFT, 4, movetoworkspace, 4"
      "${mod} ALT SHIFT, 1, movetoworkspace, 5"
      "${mod} ALT SHIFT, 2, movetoworkspace, 6"
      "${mod} ALT SHIFT, 3, movetoworkspace, 7"
      "${mod} ALT SHIFT, 4, movetoworkspace, 8"

      # Workspace
      "${mod}, H, movefocus, l"
      "${mod}, J, movefocus, d"
      "${mod}, K, movefocus, u"
      "${mod}, L, movefocus, r"
      "${mod}, 1, workspace, 1"
      "${mod}, 2, workspace, 2"
      "${mod}, 3, workspace, 3"
      "${mod}, 4, workspace, 4"
      "${mod} ALT, 1, workspace, 5"
      "${mod} ALT, 2, workspace, 6"
      "${mod} ALT, 3, workspace, 7"
      "${mod} ALT, 4, workspace, 8"
      "${mod}, mouse_down, workspace, e-1"
      "${mod}, mouse_up, workspace, e+1"
    ];

    bindm = [
      "${mod}, mouse:272, movewindow"
      "${mod}, mouse:273, resizewindow"
    ];

    bindl = [
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      "Control_L, XF86AudioMute, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1"
    ];

    bindle = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ];
  };
}
