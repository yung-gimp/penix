{
  config,
  lib,
  ...
}: let
  cfg = config.cm.programs.bemenu;
in {
  options.cm.programs.bemenu.enable = lib.mkEnableOption "Enable bemenu";

  config = lib.mkIf cfg.enable {
    programs.bemenu.enable = true;
  };
}
