{
  config,
  lib,
  ...
}:
let
  cfg = config.cm.programs.hyprland;
in
{
  options.cm.programs.hyprland.enable = lib.mkEnableOption "Enable Hyprland";
  config.programs = lib.mkIf cfg.enable {
    uwsm.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };
}
