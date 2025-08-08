{
  config,
  lib,
  ...
}: let
  cfg = config.cm.programs.git;
in {
  options.cm.programs.git.enable = lib.mkEnableOption "Enable git";

  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        userName = "yung-gimp";
        userEmail = "172232649+yung-gimp@users.noreply.github.com";
      };

      gh = {
        enable = true;
        settings.protocol = "ssh";
      };
    };
  };
}
