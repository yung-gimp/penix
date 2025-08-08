{
  config,
  lib,
  ...
}: let
  cfg = config.cm.programs.zsh;
in {
  options.cm.programs.zsh.enable = lib.mkEnableOption "Enable zsh";

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;
  };
}
