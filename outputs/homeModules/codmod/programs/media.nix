{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.cm.programs.media;
in {
  options.cm.programs.media.enable = lib.mkEnableOption "Enable media stuff";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.stremio];
  };
}
