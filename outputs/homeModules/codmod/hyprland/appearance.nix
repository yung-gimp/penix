{
  config,
  lib,
  ...
}: let
  cfg = config.cm.hyprland;
in {
  wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {
    general = {
      gaps_in = 2;
      gaps_out = 4;
    };

    decoration = {
      rounding = 4;
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      force_default_wallpaper = 0;
    };

    animation = [
      "workspaces, 1, 2, workspace, slidevert"
      "windows, 1, 2, default, gnomed"
    ];

    bezier = [
      "workspace, 0.76, 0, 0.24, 1"
    ];
  };
}
